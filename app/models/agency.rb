# Agency class refer to each Agency that support the system
class Agency < ActiveRecord::Base
  # gems required for scrapping
  require 'httparty'
  require 'mechanize'

  # associations
  has_and_belongs_to_many :users
  has_many :patients
  has_many :visits

  # validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 60 }
  validates :display_name, presence: true, uniqueness: true, length: { maximum: 60 }

  def self.scrape_agency
    run_agency_scraper
  end

  private

  def self.run_agency_scraper
    Mechanize.start do |agent|
      agent.get('https://prohealth.devero.com/login.action')
      form = agent.page.forms.first
      form.username = 'egypt'
      form.password = 'login1!2!'
      form.submit
      hsession_key = agent.page.uri.to_s.split('hhsosSessionKey=').last.split('&').first
      jsession_id = agent.cookie_jar.to_a.first.value
      response = HTTParty.post('https://prohealth.devero.com/dropDown.action',
                               body: { actionToPerform: 'getAgencies',
                                       hhsosSessionKey: hsession_key,
                                       limit: '18446744073709551615' },
                               cookies: { 'JSESSIONID' => jsession_id })
      response = JSON.parse(response.body)
      response.shift
      response.each do |agency|
        agency_record = Agency.find_by(devero_id: agency['id'])
        if agency_record
          puts 'agency already exists'
        else
          agency_record = Agency.create(phone: agency['phone'], fax: agency['fax'],
                                        zipcode: agency['zipcode'], state: agency['state'], devero_id: agency['id'],
                                        display_name: agency['displayName'], short_name: agency['shortName'].strip,
                                        address: agency['address'], address2: agency['address2'],
                                        email: agency['email'], name: agency['name'], medicare_provider_number: agency['medicareProviderNumber'],
                                        hha_agency_id: agency['hhaAgencyId'], rate: agency['rate'],
                                        fax_service_username: agency['faxServiceUsername'], fax_service_password: agency['faxServicePassword'],
                                        fax_service_account_id: agency['faxServiceAccountId'],
                                        timezone: agency['timezone'], branch_id: agency['branchId'])
          if agency_record.save
            logger.info "agency created #{agency_record.inspect}"
          else
            logger.info "error in scrapping agency #{agency_record.errors.full_messages.to_sentence}"
          end
        end
      end
    end
  end
end
