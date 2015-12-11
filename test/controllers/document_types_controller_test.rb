require 'test_helper'

class DocumentTypesControllerTest < ActionController::TestCase
  setup do
    user = FactoryGirl.create(:user)
    @job_type = job_types(:one)
    @document_type = FactoryGirl.create(:resume_doc, job_type_id: @job_type.id)
    sign_in(user)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_types)
  end

  test 'should get new' do
    get :new, job_type_id: @job_type.id
    assert_response :success
  end

  test 'should create document_type' do
    assert_difference('DocumentType.count') do
      post :create, document_type: { document_name: @document_type.document_name, job_type_id: @document_type.job_type_id }
    end

    assert_redirected_to document_type_path(assigns(:document_type))
  end

  test 'should show document_type' do
    get :show, id: @document_type
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @document_type
    assert_response :success
  end

  test 'should update document_type' do
    patch :update, id: @document_type, document_type: { document_name: @document_type.document_name, job_type_id: @document_type.job_type_id }
    assert_redirected_to document_type_path(assigns(:document_type))
  end

  test 'should destroy document_type' do
    assert_difference('DocumentType.count', -1) do
      delete :destroy, id: @document_type
    end

    assert_redirected_to document_types_path
  end
end
