require 'rails_helper'

RSpec.describe BillingReportsController, type: :controller do

  describe "GET #payments_summary" do
    it "returns http success" do
      get :payments_summary
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #weekly_bills_summary" do
    it "returns http success" do
      get :weekly_bills_summary
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #receivables_summary" do
    it "returns http success" do
      get :receivables_summary
      expect(response).to have_http_status(:success)
    end
  end

end
