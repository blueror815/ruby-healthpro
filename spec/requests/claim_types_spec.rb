require 'rails_helper'

RSpec.describe "ClaimTypes", type: :request do
  describe "GET /claim_types" do
    it "works! (now write some real specs)" do
      get claim_types_path
      expect(response).to have_http_status(200)
    end
  end
end
