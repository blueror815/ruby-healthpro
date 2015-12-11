require 'test_helper'

class AgenciesControllerTest < ActionController::TestCase
  setup do
    @agency = agencies(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:agencies)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create agency' do
    assert_difference('Agency.count') do
      post :create, agency: { address2: @agency.address2, address: @agency.address, city: @agency.city, devero_id: @agency.devero_id, display_name: @agency.display_name, email: @agency.email, fax: @agency.fax, fax_service_account_id: @agency.fax_service_account_id, fax_service_username: @agency.fax_service_username, hha_agency_id: @agency.hha_agency_id, medicare_provider_number: @agency.medicare_provider_number, name: @agency.name, phone: @agency.phone, rate: @agency.rate, short_name: @agency.short_name, state: @agency.state, timezone: @agency.timezone, zipcode: @agency.zipcode }
    end

    assert_redirected_to agency_path(assigns(:agency))
  end

  test 'should show agency' do
    get :show, id: @agency
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @agency
    assert_response :success
  end

  test 'should update agency' do
    patch :update, id: @agency, agency: { address2: @agency.address2, address: @agency.address, city: @agency.city, devero_id: @agency.devero_id, display_name: @agency.display_name, email: @agency.email, fax: @agency.fax, fax_service_account_id: @agency.fax_service_account_id, fax_service_username: @agency.fax_service_username, hha_agency_id: @agency.hha_agency_id, medicare_provider_number: @agency.medicare_provider_number, name: @agency.name, phone: @agency.phone, rate: @agency.rate, short_name: @agency.short_name, state: @agency.state, timezone: @agency.timezone, zipcode: @agency.zipcode }
    assert_redirected_to agency_path(assigns(:agency))
  end

  test 'should destroy agency' do
    assert_difference('Agency.count', -1) do
      delete :destroy, id: @agency
    end

    assert_redirected_to agencies_path
  end
end
