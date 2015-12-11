require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  setup do
    @role = roles(:one)
    user = FactoryGirl.create(:user)
    sign_in(user)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create role' do
    assert_difference('Role.count') do
      post :create, role: { name: 'test_role', short_name: 'test_role' }
    end

    assert_redirected_to roles_path
  end

  test 'should show role' do
    get :show, id: @role
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @role
    assert_response :success
  end

  test 'should update role' do
    patch :update, id: @role, role: { name: @role.name, short_name: @role.short_name }
    assert_redirected_to roles_path
  end

  test 'should destroy role' do
    assert_difference('Role.count', -1) do
      delete :destroy, id: @role
    end

    assert_redirected_to roles_path
  end
end
