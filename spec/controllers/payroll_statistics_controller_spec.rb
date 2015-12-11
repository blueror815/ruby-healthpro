require 'rails_helper'

RSpec.describe PayrollStatisticsController, type: :controller do

  describe "GET #get_exceeded_employees" do
    it "returns http success" do
      get :get_exceeded_employees
      expect(response).to have_http_status(:success)
    end
  end

end
