require 'rails_helper'

RSpec.describe "ReimbursementTimesheets", type: :request do
  describe "GET /reimbursement_timesheets" do
    it "works! (now write some real specs)" do
      get reimbursement_timesheets_path
      expect(response).to have_http_status(200)
    end
  end
end
