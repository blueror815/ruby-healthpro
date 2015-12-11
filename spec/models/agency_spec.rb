require 'rails_helper'

RSpec.describe Agency, type: :model do
  before do
    @role = FactoryGirl.create(:admin_role)
    @active_user = FactoryGirl.create(:user, email: 'active_user@prohealth.com', role_id: @role.id)
  end

  describe 'scrape agencies from devearo' do
    it 'test ::run_agency_scraper' do
      VCR.use_cassette 'Agency/scrape_agencies' do
        # expect{Agency.run_agency_scraper}.to change(Agency, :count)
      end
    end
  end
end
