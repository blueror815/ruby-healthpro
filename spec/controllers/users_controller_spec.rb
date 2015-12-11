require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature UsersController, type: :controller do
  let(:valid_session) { {} }

  before do
    @role = Role.find_by(name: 'hr')
    @role.permissions << Permission.where(action_name: 'edit', object_type: 'User')
    @user_role = Role.find_by(name: 'user')
    @hr_user = FactoryGirl.create(:user, role_id: @role.id)
    @hr_category = FormCategory.find_by(name: 'HR')
    @visits_category = FactoryGirl.create(:visits_category)

    permissions = {}
    Role.user_roles.each do |user_role|
      permissions[user_role] = {}
      User.user_abilities.each do |user_ability|
        permissions[user_role][user_ability] = 1
      end
    end
    sections = {
      '0': {
        title: 'first section',
        permissions: permissions,
        'fields': {
          '0': {
            name: 'field name',
            type: 'text'
          }
        }
      }
    }
    @custom_form_1 = FactoryGirl.create(:custom_form, title: 'first_custom', permissions: permissions, sections: sections, form_category_id: @hr_category.id)
    @custom_form_2 = FactoryGirl.create(:custom_form, title: 'second_custom', permissions: permissions, sections: sections, form_category_id: @hr_category.id)
    @custom_form_3 = FactoryGirl.create(:custom_form, title: 'third_custom', permissions: permissions, sections: sections, form_category_id: @visits_category.id)

    data = {
      '0': {
        field_name: 'some_field'
      }
    }
    FactoryGirl.create(:form_datum, custom_form_id: @custom_form_1.id, sections_data: data, creator_user_id: 1)
    FactoryGirl.create(:form_datum, custom_form_id: @custom_form_2.id, sections_data: data, creator_user_id: 1)
    FactoryGirl.create(:form_datum, custom_form_id: @custom_form_3.id, sections_data: data, creator_user_id: 1)
    @user = FactoryGirl.create(:user, email: 'user@prohealth.com', role_id: @role.id)
    FactoryGirl.create(:form_datum, custom_form_id: CustomForms::CustomForm.find_by(title: 'HR Form').id, sections_data: data, user_id: @user.id, creator_user_id: 1)
    sign_in(@user)
  end

  describe "PATCH #user" do
    context "form data" do
      it "assigns only hr forms" do
        get :edit, {:id => @user.id}, valid_session
        expect(assigns(:custom_forms_collection).map(&:form_category_id).uniq).to eq [@hr_category.id]
      end

      it 'sets correct form data' do
        patch :update, id: @user.id,
          user: FactoryGirl.attributes_for(:user, 
          email: 'prohealth@prohealth.com',
          role_id: @role.id, payment_rates_attributes: {"0": FactoryGirl.attributes_for(:payment_rate)}), custom_form_ids: [@custom_form_1.id, @custom_form_2.id]
        @user.reload
        expect(@user.form_data.map(&:custom_form).uniq.map(&:id)).to eq [CustomForms::CustomForm.find_by(title: 'HR Form').id]
      end

      it 'deletes correct forms when needed' do
        patch :update, id: @user.id,
          user: FactoryGirl.attributes_for(:user,
          email: 'prohealth@prohealth.com',
          role_id: @role.id, payment_rates_attributes: {"0": FactoryGirl.attributes_for(:payment_rate)}), custom_form_ids: [@custom_form_1]
        @user.reload
        expect(@user.form_data.map(&:custom_form).uniq.map(&:id)).to eq [CustomForms::CustomForm.find_by(title: 'HR Form').id]
      end

      it 'deletes all forms when needed' do
        patch :update, id: @user.id,
          user: FactoryGirl.attributes_for(:user, 
          email: 'prohealth@prohealth.com',
          role_id: @role.id, payment_rates_attributes: {"0": FactoryGirl.attributes_for(:payment_rate)}), custom_form_ids: []
        @user.reload
        expect(@user.form_data.map(&:custom_form).uniq.map(&:id)).to eq [CustomForms::CustomForm.find_by(title: 'HR Form').id]
      end
    end

    context 'form data user/creator' do
      it "sets correct user/creator for user's own created form data" do
        patch :update, id: @user.id,
          user: FactoryGirl.attributes_for(:user, 
          email: 'prohealth@prohealth.com',
          role_id: @role.id, payment_rates_attributes: {"0": FactoryGirl.attributes_for(:payment_rate)}), custom_form_ids: [@custom_form_1]
        @user.reload
        expect(@user.created_form_data.map(&:custom_form).uniq.map(&:id)).to eq []
        # expect(@custom_form_1.form_data.last.creator.id).to eq @user.id
        expect(@user.form_data.map(&:custom_form).uniq.map(&:id)).to eq [CustomForms::CustomForm.find_by(title: 'HR Form').id]
        # expect(@custom_form_1.form_data.last.user.id).to eq @user.id
      end

      it 'sets correct user for form data created by a user and assigned for another user' do
        @slave_user = FactoryGirl.create(:user, email: 'slave@prohealth.com', role_id: @role.id)
        patch :update, id: @slave_user.id,
          user: FactoryGirl.attributes_for(:user, 
          email: 'prohealth@prohealth.com',
          role_id: @role.id, payment_rates_attributes: {"0": FactoryGirl.attributes_for(:payment_rate)}), custom_form_ids: [@custom_form_1]
        @user.reload
        # master user side
        expect(@user.created_form_data.map(&:custom_form).uniq.map(&:id)).to eq []
        # expect(@custom_form_1.form_data.last.creator.id).to eq @user.id

        # slave user side
        expect(@slave_user.form_data.map(&:custom_form).uniq.map(&:id)).to eq []
        # expect(@custom_form_1.form_data.last.user.id).to eq @slave_user.id
      end
    end
  end

  describe "Post #deactivate_user" do
    context "with valid params" do
      it "returns http success" do
        post :deactivate_user, {id: @user.id}, valid_session
        expect(assigns(:user).deactivated?).to eq(true)
      end
    end
  end

  describe "Post #deactivate_user invalid user" do
    before do 
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it "returns http success" do
      post :deactivate_user, {id: @user.id}, valid_session
      @user.reload
      expect(@user.inactive).to be_truthy
    end
  end

  describe "Post #activate_user" do
    context "with valid params" do
      it "returns http success" do
        post :activate_user, {id: @user.id}, valid_session
        expect(assigns(:user).deactivated?).to eq(false)
      end
    end
  end
end
