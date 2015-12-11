require 'test_helper'

class FormCategoriesControllerTest < ActionController::TestCase
  setup do
    @form_category = form_categories(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:form_categories)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create form_category' do
    assert_difference('FormCategory.count') do
      post :create, form_category: { name: @form_category.name }
    end

    assert_redirected_to form_category_path(assigns(:form_category))
  end

  test 'should show form_category' do
    get :show, id: @form_category
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @form_category
    assert_response :success
  end

  test 'should update form_category' do
    patch :update, id: @form_category, form_category: { name: @form_category.name }
    assert_redirected_to form_category_path(assigns(:form_category))
  end

  test 'should destroy form_category' do
    assert_difference('FormCategory.count', -1) do
      delete :destroy, id: @form_category
    end

    assert_redirected_to form_categories_path
  end
end
