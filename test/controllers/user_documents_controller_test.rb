require 'test_helper'

class UserDocumentsControllerTest < ActionController::TestCase
  setup do
    job_type = FactoryGirl.create(:doctor)
    @user = FactoryGirl.create(:user, job_type_id: job_type.id)
    @user_document = FactoryGirl.create(:user_document, user_id: @user.id)
    sign_in(@user)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_documents)
  end

  test 'should get new' do
    get :new, user_id: @user.id
    assert_response :success
  end

  test 'should create user_document' do
    assert_difference('UserDocument.count') do
      post :create, user_document: { document_type_id: @user_document.document_type_id, user_id: @user_document.user_id }
    end

    assert_redirected_to user_document_path(assigns(:user_document))
  end

  test 'should show user_document' do
    get :show, id: @user_document
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @user_document, user_id: @user.id
    assert_response :success
  end

  test 'should update user_document' do
    patch :update, id: @user_document, user_document: { document_type_id: @user_document.document_type_id, user_id: @user_document.user_id }
    assert_redirected_to user_document_path(assigns(:user_document))
  end

  test 'should destroy user_document' do
    assert_difference('UserDocument.count', -1) do
      delete :destroy, id: @user_document
    end

    assert_redirected_to user_documents_path
  end
end
