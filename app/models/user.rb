class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # TODO: reuse validatble when scrape full data (email, password)

  require 'httparty'
  require 'mechanize'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: 'placeholder.jpg'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :display_name, presence: true
  validates :password, presence: true, :if => :validate_change_password
  validates :password_confirmation, presence: true, :if => :validate_change_password

  # associations
  has_many :licenses
  has_many :timesheets, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :hours, dependent: :destroy
  has_many :on_calls, dependent: :destroy
  has_many :reimbursement_timesheets
  has_many :comments
  has_many :user_documents
  has_many :permissions, through: :role
  has_many :payment_rates, dependent: :destroy
  has_many :created_visits, foreign_key: :assigner_id, class_name: 'Visit'
  has_many :assigned_visits, foreign_key: :assignee_id, class_name: 'Visit'
  has_many :received_notifications, foreign_key: :receiver_id, class_name: 'Notification'
  has_many :user_notifications, dependent: :destroy
  has_many :sent_notifications, foreign_key: :sender_id, through: :user_notifications
  has_many :logged_hours, foreign_key: :assignee_id, class_name: 'Hour'
  has_many :logged_on_calls, foreign_key: :user_id, class_name: 'OnCall'
  has_many :logged_reimb, foreign_key: :user_id, class_name: 'ReimbursementTimesheet'
  has_many :form_data, -> { order(:row_order) }, class_name: 'CustomForms::FormDatum', dependent: :destroy
  has_many :created_form_data, class_name: 'CustomForms::FormDatum', foreign_key: 'creator_user_id'
  belongs_to :job_type
  belongs_to :role
  has_and_belongs_to_many :availabilities
  has_and_belongs_to_many :agencies
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :coverage_areas

  # callbacks
  before_save :set_user_role
  after_save :init_user_forms_with_job_type
  after_create :create_payment_rates
  after_create :create_timesheet

  # nested attributes
  accepts_nested_attributes_for :form_data, allow_destroy: true
  accepts_nested_attributes_for :payment_rates

  #scopes
  scope :admitters, -> {joins(:role, :permissions).where('permissions.action_name = ?' ,'admit')}
  scope :payers, -> {joins(:role, :permissions).where('permissions.action_name = ?' ,'pay')}

  #flags
  attr_accessor :validate_change_password

  ABILITIES = %w[create edit show]

  def job_type_short_name
    if job_type
      job_type.job_class
    else
      'none'
    end
  end

  def deactivated?
    inactive || false
  end

  def admitter?
    self.permissions.where('permissions.action_name = ?', 'admit').first != nil
  end

  def payer?
    self.permissions.where('permissions.action_name = ?', 'pay').first != nil
  end

  def active_for_authentication?
    super && !self.deactivated?
  end

  def self.user_abilities
    self::ABILITIES
  end

  def self.scrape_users
    run_user_scraper
  end

  def update_instance(params)
    transaction do
      if self.job_type_id_changed?
        self.payment_rates.destroy_all
        self.payment_rates.new(params)
      end
      self.save
    end
  end

  def fixed_salery
    self.payment_rates.find_by(payment_method_id: 3).try(:price) || self.job_type.try(:salary_amount) || 0 #get payment rate where payment method is fixed salery 
  end

  def on_call_price
    self.payment_rates.find_by(payment_method_id: 5).try(:price) || self.job_type.try(:on_call_price) || 0 #get payment rate where payment method is fixed salery 
  end

  def create_payment_rates
    if self.payment_rates.empty?
      if self.job_type
        self.job_type.payment_method_ids.each do |method|
          if method == '1'
            self.job_type.visit_types.each do |type|
              self.payment_rates.where(payment_method_id: method.to_i, visit_type_id: type.id).first_or_create
            end
          # elsif method == '2'
          #   self.job_type.hour_types.each do |type|
          #     self.payment_rates.where(payment_method_id: method.to_i, hour_type_id: type.id).first_or_create
          #   end
          elsif method == '4'
            Reimbursement.all.each do |type|
              self.payment_rates.where(payment_method_id: method.to_i, reimbursement_id: type.id).first_or_create
            end
          else
            self.payment_rates.where(payment_method_id: method.to_i).first_or_create
          end
        end
      end
    end
  end

  def self.scrape_users_agencies
    Mechanize.start do |agent|
      devero_login(agent)
      hsession_key, jsession_id, htoken_key = set_session_tokens(agent)
      agencies = Agency.all

      User.where.not(devero_id: nil).includes(:agencies).each do |user|
        get_user_action(agent, user.devero_id, hsession_key, htoken_key)
        set_user_agencies(agent, user, agencies)
      end
    end
  end

  def self.set_session_tokens(agent)
    hsession_key = agent.page.uri.to_s.split('hhsosSessionKey=').last.split('&').first
    jsession_id = agent.cookie_jar.to_a.first.value
    htoken_key = agent.page.search('#hhsosTokenKey').attribute('value').value
    return hsession_key, jsession_id, htoken_key
  end

  def self.devero_login(agent)
    agent.get('https://prohealth.devero.com/login.action')
    form = agent.page.forms.first
    form.username = 'egypt'
    form.password = 'login1!2!'
    form.submit
  end

  def self.set_user_agencies(agent, user, agencies)
    user_agencies = agent.page.search('#selectedAgencies').attribute('value').value.split(',')
    user_agencies.each do |agency|
      agency = agencies.detect{ |i| i.devero_id == agency.split('_').last.to_i }
      user.agencies << agency if agency && !user.agencies.include?(agency)
    end
    puts "#{user.display_name} agencies updated"
  end

  def self.get_user_action(agent, user_id, hsession_key, htoken_key)
    agent.post('https://prohealth.devero.com/createUser.action', 
                [['selectedUserId', user_id],
                ['hhsosTokenKey', htoken_key],
                ['agencySearchText_selectedAgencyIds', '(All Agencies)'],
                ['mainMenuForward', 'viewUsers.action'],
                ['hhsosSessionKey', hsession_key ]])
  end

  private
    def create_timesheet
      if Payroll.any?
        Payroll.last.timesheets.create(user_id: self.id)
      end
    end

    # using method missing to define role checking methods
    def method_missing(method_sym, *arguments, &block)
      eigenclass = class << self; self; end
      role = Role.find_by(name: method_sym.to_s.tr('?', ''))
      if role
        eigenclass.class_eval do
          define_method(method_sym) do
            role_id == role.id
          end
        end
      else
        super
      end
      send(method_sym)
    end

    def init_user_forms_with_job_type
      if self.job_type_id_changed?
        job_type_form_ids = job_type.custom_forms.map(&:id)

        # delete hr forms that doesn't belong to current job_type
        # hr_custom_forms = FormCategory.find_by(name: 'HR').custom_forms
        # self.form_data.where(custom_form_id: (hr_custom_forms.map(&:id) - job_type_form_ids)).delete_all

        job_type_form_ids.each do |cf_id|
          form_data.where(custom_form_id: cf_id).first_or_create
        end
      end
    end

    def set_user_role
      self.role = Role.role_is_a('user') unless role_id.present?
    end

    def self.run_user_scraper
      Mechanize.start do |agent|
        agent.get('https://prohealth.devero.com/login.action')
        form = agent.page.forms.first
        form.username = 'egypt'
        form.password = 'login1!2!'
        form.submit

        hsession_key = agent.page.uri.to_s.split('hhsosSessionKey=').last.split('&').first
        jsession_id = agent.cookie_jar.to_a.first.value
        # send http xhr
        response = HTTParty.post('https://prohealth.devero.com/dropDown.action',
                                 body: { actionToPerform: 'getUsers',
                                         searchType: 'search',
                                         selectedOnCalls: '1,0',
                                         selectedTypes: '0,1',
                                         showAgency: 'true',
                                         selectedUserTypeIds: '23,2,24,5,19,21,8,9,10,1,12,6,13,14,26,11,15,16,18,25',
                                         hhsosSessionKey: hsession_key,
                                         searchString: '',
                                         start: 0,
                                         limit: '18446744073709551615' },
                                 cookies: { 'JSESSIONID' => jsession_id })
        response = JSON.parse(response.body)
        # remove first element of the array as it's records count
        response.shift
        hr_form = CustomForms::CustomForm.find_by(title: 'HR Form')
        dates_form = CustomForms::CustomForm.find_by(title: 'license expiration dates')
        checklist_form = CustomForms::CustomForm.find_by(title: 'checklist')
        role = Role.where(short_name: 'user').first
        # get all field types
        field_types = CustomForms::FieldType.all
        response.each_with_index do |user, _i|
          user['visibility'] = user['visibility'] == 'Active' ? 1 : 0
          @job_type = JobType.where(title: user['userTypeShort'], hour_price: 10).first_or_create
          hr_user = User.find_by(email: 'hr@prohealth.com')
          user_email = user['email'].blank? ? "#{user['displayName'].parameterize}@prohealth.com" : user['email']
          user['onCall'] = user['onCall'] == true ? 1 : 0

          reimbursements = {"0"=>{ payment_method_id: "3", price: "" },
                            "1"=>{ payment_method_id: "2", price: "" }}
          index = 2
          Reimbursement.find_each do |reimbursement|
            reimbursements[index] = { reimbursement_id: reimbursement.id, payment_method_id: "4", price: "" }
            index += 1
          end


          user_record = User.create(devero_id: user['id'],
                                    role_id: role.id,
                                    job_type_id: @job_type.id,
                                    email: user_email,
                                    display_name: user['displayName'].gsub(/\(.*\)/, ""),
                                    password: '123456789',
                                    username: user['username'],
                                    payment_rates_attributes: reimbursements,
                                    form_data_attributes: {
                                      '0' => {
                                        creator_user_id: hr_user.id,
                                        custom_form_id: hr_form.id,
                                        :sections_data => {
                                            "#{hr_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'first_name' }.id) }.id }" =>
                                              user['fullName'].split(',')[-1].strip,
                                            "#{hr_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'last_name' }.id) }.id }" =>
                                              user['fullName'].gsub(",#{user['fullName'].split(',')[-1]}", '').strip,
                                            "#{hr_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'birth_date' }.id) }.id }" =>
                                              '',
                                            "#{hr_form.form_sections[1].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'phone' }.id) }.id }" =>
                                              user['phoneNum'],
                                            "#{hr_form.form_sections[1].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'phone' }.id) }.id }" =>
                                              user['cellPhone'],
                                            "#{hr_form.form_sections[1].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'fax' }.id) }.id }" =>
                                              user['faxNum'],
                                            "#{hr_form.form_sections[1].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'address' }.id) }.id }" =>
                                              user['address'],
                                            "#{hr_form.form_sections[1].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'address2' }.id) }.id }" =>
                                              user['address2'],
                                            "#{hr_form.form_sections[1].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'city' }.id) }.id }" =>
                                              user['city'],
                                            "#{hr_form.form_sections[1].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'zipcode' }.id) }.id }" =>
                                              user['zipCode'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'title' }.id) }.id }" =>
                                              user['userTitle'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'status' }.id) }.id }" =>
                                              user['visibility'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'state' }.id) }.id }" =>
                                              user['state'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'color' }.id) }.id }" =>
                                              user['color'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'code' }.id) }.id }" =>
                                              user['userCode'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'caregiver_code' }.id) }.id }" =>
                                              user['caregiverCode'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'user_type' }.id) }.id }" =>
                                              user['userType'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'agency_short' }.id) }.id }" =>
                                              user['agencyShort'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'on_call' }.id) }.id }" =>
                                              user['onCall'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'hire_date' }.id) }.id }" =>
                                              user['hireDate'],
                                            "#{hr_form.form_sections[2].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'departure_date' }.id) }.id }" =>
                                              user['departureDate']
                                        }
                                      },
                                      '1' => {
                                        creator_user_id: hr_user.id,
                                        custom_form_id: checklist_form.id,
                                        :sections_data => {
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'resume' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'employment_application' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'background_check' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'refrences' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'offer_letter' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'signed_job_description' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'confidentiality_agreement' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'reporting_of_abuse' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'oriantation_checklist' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'w_forms' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'ee_acknowledgement' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'joing_comission' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'clinician_bag_agreement' }.id) }.id }" =>
                                              "file",
                                            "#{checklist_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'laptop_user_agreement' }.id) }.id }" =>
                                              "file"
                                        }
                                      },
                                      '2' => {
                                        creator_user_id: hr_user.id,
                                        custom_form_id: dates_form.id,
                                        :sections_data => {
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'physical_exam_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'tb_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'chest_x_ray_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'drug_screen_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'mmr_expration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'varicella_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'hep_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'influenza_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'driving_license_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'profissional_license_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'cpr_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'auto_insurance_expiration' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'laptop_type' }.id) }.id }" =>
                                              'expirable_file',
                                            "#{dates_form.form_sections[0].section_fields.detect{ |s| s.field_type_id == (field_types.detect{ |i| i.name == 'laptop_serial_number' }.id) }.id }" =>
                                              'expirable_file'
                                        }
                                      }
                                    })
          if user_record.persisted?
            puts "user created #{user_record.inspect}"
            unless user_record.agencies.any?
              user['agency'].split(',').each do |agency|
                agency = Agency.find_by(name: agency)
                user_record.agencies << agency if agency
              end
            end
          else
            puts "error in scrapping user #{user['username']} #{user_record.errors.full_messages.to_sentence}"
          end
        end
      end
    end
end
