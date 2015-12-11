require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  setup do
    user = FactoryGirl.create(:admin)
    sign_in(user)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end
end
