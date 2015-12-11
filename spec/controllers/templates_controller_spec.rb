require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do

  describe "GET #floating_menu" do
    it "returns http success" do
      get :floating_menu
      expect(response).to have_http_status(:success)
    end
  end

end
