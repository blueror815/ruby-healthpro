class InsuranceCompany < ActiveRecord::Base
  require 'httparty'
  require 'mechanize'
  # associations
  has_many :bills
  has_many :payments
  has_and_belongs_to_many :patients

  # validations
  validates :name, presence: true
  validates :uniq_name, presence: true
  validates :uniq_name, uniqueness: { case_sensitive: false }

  # callbacks
  before_save :titleize_name

  def self.scrape_insurance_companies
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
                               body: { actionToPerform: 'getLibraries',
                                       searchType: 'search',
                                       showInactive: 'true',
                                       selectedVisibilities:1,
                                       libraryName: 'insurance',
                                       hhsosSessionKey: hsession_key,
                                       start: 0,
                                       limit: '18446744073709551615' },
                               cookies: { 'JSESSIONID' => jsession_id })
      response = JSON.parse(response.body)
      # remove first element of the array as it's records count
      response.shift
      response.each do |insurance|
        insurance_record = InsuranceCompany.where(devero_id: insurance['id'],
                                                  name: insurance['name'],
                                                  phone: insurance['phone'],
                                                  state: insurance['state'],
                                                  address: insurance['address'],
                                                  address2: insurance['address2'],
                                                  code: insurance['code'],
                                                  episodic: insurance['episodic'],
                                                  city: insurance['city'],
                                                  display_name: insurance['display_name'],
                                                  active: insurance['active'].to_i,
                                                  zipcode: insurance['zipcode'],
                                                  category: insurance['category']).first_or_create
        if insurance_record.persisted?
          puts "insurance company created #{insurance_record.inspect}"
        else
          puts "error in scrapping insurance company #{insurance['name']} #{insurance_record.errors.full_messages.to_sentence}"
        end
      end
    end
  end

  private
    def titleize_name
      self.name.downcase.titleize
    end
end
