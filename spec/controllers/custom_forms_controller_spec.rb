require 'rails_helper'

RSpec.feature CustomForms::CustomFormsController, type: :controller do
  routes { CustomForms::Engine.routes }
  let(:valid_session) { {} }

    before do
      @role = Role.find_by(name: 'admin')
      @job_type = FactoryGirl.create(:simple_job_type)
      @user = FactoryGirl.create(:user, role_id: @role.id)
      sign_in(@user)
      permissions = {}
      Role.user_roles.each do |user_role|
        permissions[user_role] = {}
        User.user_abilities.each do |user_ability|
          permissions[user_role][user_ability] = 1
        end
      end

      # @custom_form = FactoryGirl.create(:custom_form, title: 'first_custom', permissions: permissions, form_sections_attributes: {})
    end

  describe "DELETE #destroy" do
    context "with assigned users" do
      it "destroys the requested custom form stops " do
        data = {
          '0': {
            field_name: 'some_field'
          }
        }
        FactoryGirl.create(:form_datum, custom_form_id: @custom_form.id, sections_data: data, creator_user_id: @user.id)

        expect do
          delete :destroy, { id: @custom_form.id }, valid_session
        end.to_not change(CustomForms::CustomForm, :count)
      end
    end

     context "without assigned users " do
      it "destroys the requested custom form" do
        expect {
          delete :destroy, {:id => @custom_form.id}, valid_session
        }.to change(CustomForms::CustomForm, :count).by(-1)
      end
    end
  end

  describe 'GET #index' do
    it 'should retrieve all custom_forms & render index template' do
      get :index
      assert_response :success
      assert_template :index
      expect(assigns(:custom_forms)).to eq CustomForms::CustomForm.all
    end
  end

  describe 'GET #new' do
    it 'should instantiate instance of custom_forms & render new template' do
      get :new
      assert_response :success
      assert_template :new
      expect(assigns(:custom_form)).to be_a_new CustomForms::CustomForm
    end
  end
end
