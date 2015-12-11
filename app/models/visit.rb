class Visit < ActiveRecord::Base
  # constants
  PROGRESS_STATE = %w(unassigned assigned visited missed pending approved admited paid rejected)

  # associations
  belongs_to :assigner, class_name: 'User', foreign_key: 'assigner_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id'
  belongs_to :patient
  belongs_to :visit_type
  belongs_to :agency
  has_many :reimbursements_visits
  has_many :reimbursements, through: :reimbursements_visits
  accepts_nested_attributes_for :reimbursements_visits, allow_destroy: true
  has_many :comments, :as => :commentable, dependent: :destroy
  belongs_to :timesheet
  has_many :notifications, :as => :notifiable, dependent: :destroy
  
  # callbacks
  before_save :init_progress_state
  after_create :create_reimbursements

  # validations
  validates :visit_type_id, presence: true
  validates :assignee_id, presence: true

  # scope
  scope :user_visits, ->(assignee_id) { where(assignee_id: assignee_id) }
  scope :price_editable_visits, -> {where(progress_state: ['unassigned', 'assigned', 'visited', 'missed', 'pending'])}

  require 'httparty'
  require 'mechanize'

  def self.scrape_visits
    run_visits_scraper
  end

  def update_visit_total_price
    if ['unassigned', 'assigned', 'visited', 'missed', 'pending'].include? self.progress_state
      total_price = self.reimbursements_visits.map do |rv|
 
        rv.action_count *  rv.reimbursement.riembursement_price(self.assignee)
      end
      reimbursements_price_sum = 0
      reimbursements_price_sum = total_price.inject{|reimbursements_price_sum, e| reimbursements_price_sum + e } || 0
      visit_total_price = reimbursements_price_sum + self.visit_price
      self.update_attribute(:total_price, visit_total_price)
    end

  end

  def visit_price
    if self.assignee
      self.assignee.payment_rates.find_by(visit_type_id: self.visit_type.try(:id)).try(:price) || self.visit_type.try(:price)
    else
      0
    end
  end

  def price
    price = visit_price
    self.reimbursements.each do |r|
      price = price + r.price
    end
  end
  def user
    self.assignee
  end

  def set_reimbursements
    self.visit_type.reimbursements.each do |reimbursement|
      
      self.reimbursements << reimbursement unless self.reimbursements.include? reimbursement
    end
  end

  private

  def tiem_in_type
    self.time_in.is_a? Time 
  end

  def tiem_out_type
    self.time_out.is_a? Time 
  end

  # validate that progress state is valid 
  def validate_progress_state
    errors.add(:progress_state, 'is invalid') unless (PROGRESS_STATE.include? self.progress_state)  || (self.progress_state == nil)
  end

  def init_progress_state
    unless self.progress_state 
      if self.assignee
        self.progress_state = 'visited'
      else
        self.progress_state = 'unassigned'
      end
    end
  end
    
  def create_reimbursements
    self.visit_type.reimbursements.each do |reimbursement|
      self.reimbursements << reimbursement
    end
  end

  def self.run_visits_scraper
    Mechanize.start do |agent|
      agent.get('https://prohealth.devero.com/login.action')
      form = agent.page.forms.first
      form.username = 'egypt'
      form.password = 'login1!2!'
      form.submit

      @hsession_key = agent.page.uri.to_s.split('hhsosSessionKey=').last.split('&').first
      @jsession_id = agent.cookie_jar.to_a.first.value
      @hhsosTokenKey = agent.page.search("[name='hhsosTokenKey']").first.attributes['value'].value
      page = Visit.get_page(agent, '1')

      pages = page.search('.numPages').last.text
      (1..pages.to_i).each do |index|
        table_rows = page.search('#reportTbl tbody tr')
        table_rows.each_with_index do |row, _row_ind|
          visit = {}
          patient = {}
          row.search('td').each_with_index do |cell, i|
            case i
            when 0
              patient[:display_name] = cell.text.strip
            when 1
              patient[:medical_record_number] = cell.text.strip
            when 2
              status = StatusChart.where(name: cell.text).first_or_create
              patient[:status_chart_id] = status.id
            when 3
              agency = Agency.find_by(name: cell.text.strip)
              visit[:agency_id] = agency.try(:id)
              patient[:agency_id] = agency.try(:id)
              # when 4
              # patient.merge! insurance: cell.text.strip.strip
            when 5
              visit_type = VisitType.where(title: cell.text.strip, price: 0).first_or_create

              visit[:visit_type_id] = visit_type.id
            when 6
              visit[:form_status] = cell.text.strip 
            when 7
              visit[:date] = Date.parse(cell.text).strftime('%Y-%m-%d')
            when 8
              visit[:assignee_id] = User.find_by(display_name: cell.text).try(:id)
            when 11
              visit[:billing_code] = cell.text.strip
            when 12
              visit[:time_in] = (cell.text).to_time if cell.text.present?
            when 13
              visit[:time_out] = (cell.text).to_time cell.text.present?
            end
          end
          patient[:email] = "#{patient[:display_name].parameterize}@prohealth.com"
          patient = Patient.where(patient).first_or_create
          visit[:patient_id] = patient.id
          visit[:progress_state] = "visited"
          visit[:total_price] = "0"
          visit = Visit.where(visit).first_or_create
          if visit.persisted?
            puts "visit created #{visit.inspect}"
            unless visit.visit_type.job_types.include? visit.assignee.job_type
              visit.visit_type.job_types << visit.assignee.job_type
            end
          else
            puts "error in scrapping #{visit.errors.full_messages.to_sentence}"
          end
        end
        page = Visit.get_page(agent, (index + 1).to_s) if page.search('.nextLink').any?
      end
    end
  end

  def self.get_page(agent, page_num)
    number_of_entries = Rails.env.development? ? '100' : '1000'
    agent.post('https://prohealth.devero.com/runReport.action',
               hhsosSessionKey: @hsession_key,
               hhsosTokenKey: @hhsosTokenKey,
               desc: '1',
               endDate: Time.now.strftime("%m/%d/%Y"),
               mainMenuForward: 'adminMenu.action',
               maxResults: number_of_entries,
               nextStart: '100',
               order: 'visitDate',
               pagingPageNum: page_num,
               previousStart: '0',
               printType: 'specified',
               pushType:  'selectedUsers',
               reportId:  '17',
               selectedActivityStatuses: 'Submitted,Resubmitted,Cosigning,Shared,Pending,Reviewed,Completed',
               selectedFormIds: '73,108,109,76,123,114,110,111,81,82,179,174,64,66,67,142,68,65,69,70,143,71,129,135,130,131,133,134,181,177,83,84,136,132,112,113,117',
               selectedMarkAsFilter3: 'both',
               selectedPatientId: '-1',
               selectedUserId: '-1',
               sendType: 'push',
               start: '0',
               startDate: '11/25/2010')
  end
end
