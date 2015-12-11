class Patient < ActiveRecord::Base
  require 'httparty'
  require 'mechanize'

  # associations
  has_many :payments
  has_many :visits, dependent: :destroy
  has_many :bills
  has_many :form_data, class_name: 'CustomForms::FormDatum' , dependent: :destroy
  belongs_to :status
  belongs_to :status_chart
  belongs_to :agency
  has_and_belongs_to_many :insurance_companies

  accepts_nested_attributes_for :form_data
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "placeholder.jpg"

  # validations
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  # validates :email, presence: true
  validates :display_name, presence: true

  def self.scrape_patients_insurances
    Mechanize.new do |agent|
      agent.get('https://prohealth.devero.com/login.action')
      form = agent.page.forms.first
      form.username = 'egypt'
      form.password = 'login1!2!'
      form.submit
      agent.page.forms.first.submit

      hsession_key = agent.page.search("[name='hhsosSessionKey']").attr('value').value
      jsession_id = agent.cookie_jar.to_a.first.value

      Patient.all.each do |patient|
        agent.get("https://prohealth.devero.com/patientProfileSelection.action?patientId=#{patient.devero_id}&hhsosSessionKey=#{hsession_key}")
        search_strings = []
        if agent.page.search("[name='value(PrimaryInsuranceID)']").any?
          search_strings << agent.page.search("[name='value(PrimaryInsuranceID)']").attr('value').value
          search_strings << agent.page.search("[name='value(SecondaryInsuranceID)']").attr('value').value
          search_strings << agent.page.search("[name='value(TertiaryInsuranceID)']").attr('value').value
          search_strings << agent.page.search("[name='value(QuaternaryInsuranceID)']").attr('value').value
          companies = []
          search_strings.each do |search_string|
            puts "retrieving insurance_company with id:" + search_string
            unless search_string == '-1'
              response = HTTParty.post('https://prohealth.devero.com/dropDown.action', 
                                  body: { searchString: search_string,
                                          searchType: 'id',
                                          start: '0',
                                          limit: '100',
                                          orders: 'name asc',
                                          hhsosSessionKey: hsession_key,
                                          patientId: patient.devero_id,
                                          actionToPerform: 'getLibraries',
                                          libraryName: 'insurance'},
                                  cookies: { 'JSESSIONID' => jsession_id })
              # remove first element of response as it's array count
              response.shift

              response.each do |company|
                patient_company = InsuranceCompany.find_by(uniq_name: company['name'].downcase.titleize)
                unless patient_company 
                  patient_company = InsuranceCompany.create(devero_id: company['id'], name: company['name'], phone: company['phone'],
                                       state: company['state'], code: company['code'],
                                       active: company['active'], display_name: company['displayName'],
                                       episodic: company['episodic'], zipcode: company['zipcode'],
                                       address: company['address'], address2: company['address2'],
                                       city: company['city'], category: company['category'], 
                                       uniq_name: company['name'].downcase.titleize )
                end
                companies << patient_company
              end
            end
          end
          patient.insurance_companies = companies
          if patient.save!
            puts "#{patient.display_name} insurance companies added"
          else
            puts "error in scrapping companies #{patient.errors}"
          end
        end
      end
    end
  end

  def self.scrape_discharged_dates
    Mechanize.new do |agent|
      agent.get('https://prohealth.devero.com/login.action')
      form = agent.page.forms.first
      form.username = 'egypt'
      form.password = 'login1!2!'
      form.submit
      agent.page.forms.first.submit

      hsession_key = agent.page.search("[name='hhsosSessionKey']").attr('value').value
      jsession_id = agent.cookie_jar.to_a.first.value

      Patient.all.each  do |patient|
        agent.post('https://prohealth.devero.com/patientCharts.action',
        [ ['hhsosSessionKey', hsession_key],
          ['hhsosTokenKey', jsession_id],
          ['actionToPerform', 'changePatient'],
          ['isShared', 'false'],
          ['formVersionId', '-1'],
          ['groupId', '-1'],
          ['individualFormVersionId', '-1'],
          ['mainMenuForward', 'adminMenu.action'],
          ['sendType', 'push'],
          ['pushType', 'selectedUsers'],
          ['selectedPatientId', patient.devero_id] ])

        charts = agent.page.search("span.mainBigBoldText.unselectable")
        date_regex = /\d{1,2}\/\d{1,2}\/\d{4}/

        charts.each do |chart|
          text = chart.text.squish
          if chart == charts.first && text.include?('Discharge Date')
            patient.discharged_date = text.scan(date_regex).last.to_date
            if charts.length == 1
              patient.soc_date = text.scan(date_regex).first.to_date
            end
          elsif chart == charts.last
            patient.soc_date = text.scan(date_regex).first.to_date
          end
          patient.save!
          puts "#{patient.inspect}"
        end
      end
    end
  end

  def self.scrape_patients
    Mechanize.start do |agent|
      User.devero_login(agent)
      hsession_key, jsession_id, htoken_key = User.set_session_tokens(agent)
      response = get_patients(hsession_key, jsession_id)

      hr_user = User.find_by(email: 'hr@prohealth.com')
      response.each_with_index do |patient, i|
        patient_record = create_scrapped_patient_record(patient)
        if patient_record.persisted?
          puts "Patient #{patient['displayName']} created."
          agent.get("https://prohealth.devero.com/patientProfileSelection.action?patientId=#{patient['id']}&hhsosSessionKey=#{hsession_key}")
          scrape_patient_extra_data(patient_record, agent, hsession_key)
          scrape_patient_insurance_companies(agent, patient, hsession_key, jsession_id, patient_record)
        else
          puts "Error in scrapping patient #{patient['displayName']} #{patient_record.errors.full_messages.to_sentence}"
        end
      end
    end
    scrape_discharged_dates
  end

  def self.scrape_patient_insurance_companies(agent, patient, hsession_key, jsession_id, patient_record)
    if agent.page.search("[name='value(PrimaryInsuranceID)']").any?
      search_strings = set_compnaies_search_string(agent)
      companies = []
      search_strings.each do |search_string|
        unless search_string == '-1'
          response = get_companies(search_string, hsession_key, jsession_id, patient['id'])
          response.each do |company|
            puts "id: #{company['id']}"
            puts "td: #{search_string}"
            companies = set_patient_companies(companies, company)
          end
        end
      end
      patient_record.insurance_companies = companies
      if patient_record.save!
        puts "#{patient_record.display_name} insurance companies added"
      else
        puts "error in scrapping companies #{patient_record.errors}"
      end
    end
  end

  def self.get_patients(hsession_key, jsession_id)
    response = HTTParty.post('https://prohealth.devero.com/dropDown.action',
                         body: { searchString: '',
                                 actionToPerform: 'getPatients',
                                 searchType: 'search',
                                 showOnlyExportable: 'false',
                                 showRemoved: 'false',
                                 showInactive: 'true',
                                 selectedStatusIds: '19,23,25,24,21,1,26,22,10,4,8,14,2,15,9,11,17,3,16,18,20,5,7,6,12,13',
                                 selectedTypes: '0,1',
                                 includeDeleted: 'false',
                                 libraryFilters: '',
                                 hhsosSessionKey: hsession_key,
                                 start: 0,
                                 limit: '999999999' },
                         cookies: { 'JSESSIONID' => jsession_id })
    response = JSON.parse(response.body)
    response.shift
    response
  end

  def self.create_scrapped_patient_record(patient)
    patient['visibility'] = patient['visibility'] == 'Active' ? true : false
    Patient.where({
      display_name: patient['displayName'],
      email: patient['email'].blank? ? "#{patient["displayName"].parameterize}@prohealth.com" : patient['patient_email'],
      devero_id: patient['id'],
      medical_record_number: patient['medicalRecordNum'],
      agency_id: patient['agencyId'],
      status_id: patient['statusId']
    }).first_or_create
  end

  def self.scrape_patient_extra_data(patient, agent, hsession_key)
    if agent.page.search("[name='value(M0040City)']").empty?
      agent = patient_profile_page(patient, agent, hsession_key)
    end
    patient.city = agent.page.search("[name='value(M0040City)']").attribute('value').value
    patient.zipcode = agent.page.search("[name='value(M0060ZipCode)']").attribute('value').value
    patient.street = agent.page.search("[name='value(M0040Address)']").attribute('value').value
    patient.apartment_number = agent.page.search("[name='value(M0040Address2)']").attribute('value').value
    patient.phone = agent.page.search("[name='value(M0040Phone)']").attribute('value').value
    patient.emergency_contact = agent.page.search("[name='value(EmergencyContact)']").attribute('value').value
    patient.emergency_contact_phone = agent.page.search("[name='value(EmergencyContactNum)']").attribute('value').value
    patient.state = agent.page.search("[name='value(M0050)']").attribute('value').value
    patient.save
  end

  def self.patient_profile_page(patient, agent, hsession_key)
      agent.post('https://prohealth.devero.com/buildForm.action',
                [ ['hhsosSessionKey', hsession_key],
                  ['mainMenuForward', 'patientProfileSelection.action'],
                  ['activityId', '231937'],
                  ['episodeId', '9960'],
                  ['formId', '20'],
                  ['patientId', patient.devero_id] ])
      return agent
  end

  def self.set_compnaies_search_string(agent)
    search_strings = []
    search_strings << agent.page.search("[name='value(PrimaryInsuranceID)']").attribute('value').value
    search_strings << agent.page.search("[name='value(SecondaryInsuranceID)']").attribute('value').value
    search_strings << agent.page.search("[name='value(TertiaryInsuranceID)']").attribute('value').value
    search_strings << agent.page.search("[name='value(QuaternaryInsuranceID)']").attribute('value').value
  end

  def self.get_companies(search_string, hsession_key, jsession_id, patient_id)
    puts "retrieving insurance_company with id:" + search_string
    response = HTTParty.post('https://prohealth.devero.com/dropDown.action', 
                        body: { searchString: search_string,
                                searchType: 'id',
                                start: '0',
                                limit: '100',
                                orders: 'name asc',
                                hhsosSessionKey: hsession_key,
                                patientId: patient_id,
                                actionToPerform: 'getLibraries',
                                libraryName: 'insurance'},
                        cookies: { 'JSESSIONID' => jsession_id })
    # remove first element of response as it's array count
    response.shift
    response
  end

  def self.set_patient_companies(companies, company)
    patient_company = InsuranceCompany.find_by(uniq_name: company['name'].downcase.titleize)
    unless patient_company 
      patient_company = InsuranceCompany.create(devero_id: company['id'], name: company['name'], phone: company['phone'],
                           state: company['state'], code: company['code'],
                           active: company['active'], display_name: company['displayName'],
                           episodic: company['episodic'], zipcode: company['zipcode'],
                           address: company['address'], address2: company['address2'],
                           city: company['city'], category: company['category'], uniq_name: company['name'].downcase.titleize )
    end
    companies << patient_company
  end
end
