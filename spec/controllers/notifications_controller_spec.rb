require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all notifications as @notifications" do
      notification = Notification.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:notifications)).to eq([notification])
    end
  end
end
