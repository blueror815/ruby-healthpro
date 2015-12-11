class Status < ActiveRecord::Base
  has_many :patients
  validates :title, presence: true, length: { maximum: 60 }

  require 'httparty'
  require 'mechanize'

  def self.scrape_statuses
    run_statuses_scraper
  end

  private

  def self.run_statuses_scraper
    Mechanize.start do |agent|
      agent.get('https://prohealth.devero.com/login.action')
      form = agent.page.forms.first
      form.username = 'egypt'
      form.password = 'login1!2!'
      form.submit
      hsession_key = agent.page.uri.to_s.split('hhsosSessionKey=').last.split('&').first
      jsession_id = agent.cookie_jar.to_a.first.value

      response = HTTParty.post('https://prohealth.devero.com/dropDown.action',
                               body: { searchString: '19,23,25,24,21,1,26,22,10,4,8,14,2,15,9,11,17,3,16,18,20,5,7,6,12,13',
                                       actionToPerform: 'getStatuses',
                                       searchType: 'id',
                                       initialId: '19,23,25,24,21,1,26,22,10,4,8,14,2,15,9,11,17,3,16,18,20,5,7,6,12,13',
                                       hhsosSessionKey: hsession_key,
                                       start: 0,
                                       limit: '999999999' }, # 999999999
                               cookies: { 'JSESSIONID' => jsession_id })

      response = JSON.parse(response.body)
      response.shift

      response.each do |status|
        status_record = Status.find_by(devero_id: status['id'])
        if status_record
          puts 'status already exists'
        else
          status_record = Status.create(devero_id: status['id'],
                                        title: status['displayName'])
          if status_record.save
            puts "status created #{status_record.inspect}"
          else
            puts "error in scrapping status #{status_record.errors.full_messages.to_sentence}"
          end
        end
      end
    end
  end
end
