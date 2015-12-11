require 'rails_helper'

RSpec.feature CustomForms::FormDataController, type: :controller do
  routes { CustomForms::Engine.routes }

  let(:valid_session) { {} }

  describe 'POST #create' do
    before do
      @role = FactoryGirl.create(:admin_role)
      @job_type = FactoryGirl.create(:simple_job_type)
      @user = FactoryGirl.create(:user, role_id: @role.id)
      sign_in(@user)
      permissions = {}
      Role.user_roles.each do |user_role|
        permissions[user_role] = {}
        User.user_abilities.each do |user_ability|
          permissions[user_role][user_ability] = '1'
        end
      end
      sections = {
        '0': {
          title: 'first section',
          permissions: permissions,
          'fields': {
            '0': {
              name: 'required_field',
              type: 'text',
              required: '1'
            },
            '1': {
              name: 'field_name',
              type: 'text'
            }
          }
        }
      }
      @custom_form = FactoryGirl.create(:custom_form, title: 'first_custom', permissions: permissions, sections: sections)

      @valid_data = {
        '0': {
          required_field: 'some_field',
          field_name: 'some_field'
        }
      }
      @invalid_data = {
        '0': {
          field_name: 'some_field'
        }
      }

      @empty_invalid_data = {
        '0': {
          required_field: '',
          field_name: 'some_field'
        }
      }
    end

    context 'with valid params' do
      it 'creates a new form_datum' do
        expect do
          post :create, { form_datum: FactoryGirl.attributes_for(:form_datum,
                                                                 sections_data: @valid_data),
                          custom_form_id: @custom_form.id
           }, valid_session
        end.to change(CustomForms::FormDatum, :count).by(1)
      end

      it 'assigns a newly created form_datum as @form_datum' do
        post :create, { form_datum: FactoryGirl.attributes_for(:form_datum,
                                                               sections_data: @valid_data),
                        custom_form_id: @custom_form.id }, valid_session
        expect(assigns(:form_datum)).to be_a(CustomForms::FormDatum)
        expect(assigns(:form_datum)).to be_persisted
      end

      context 'form data user/creator' do
        it "sets correct user/creator for user's own created form data but for not for him" do
          post :create, { form_datum: FactoryGirl.attributes_for(:form_datum,
                                                                 sections_data: @valid_data),
                          custom_form_id: @custom_form.id }, valid_session
          expect(assigns(:form_datum).creator.id).to eq @user.id
          expect(assigns(:form_datum).user).to eq nil
          expect(assigns(:form_datum)).to eq @user.created_form_data.last
        end

        it "sets correct user/creator for user's own created form data and for himself" do
          post :create, { form_datum: FactoryGirl.attributes_for(:form_datum,
                                                                 sections_data: @valid_data, user_id: @user.id),
                          custom_form_id: @custom_form.id }, valid_session
          expect(assigns(:form_datum).creator.id).to eq @user.id
          expect(assigns(:form_datum).user.id).to eq @user.id
          expect(assigns(:form_datum)).to eq @user.created_form_data.last
          expect(assigns(:form_datum)).to eq @user.form_data.last
        end

        it 'sets correct user for form data created by a user and assigned for another user' do
          @slave_user = FactoryGirl.create(:user, email: 'slave@prohealth.com', role_id: @role.id)
          post :create, { form_datum: FactoryGirl.attributes_for(:form_datum,
                                                                 sections_data: @valid_data, user_id: @slave_user.id),
                          custom_form_id: @custom_form.id }, valid_session
          # master side
          expect(assigns(:form_datum).creator.id).to eq @user.id
          expect(assigns(:form_datum)).to eq @user.created_form_data.last

          # slave side
          expect(assigns(:form_datum).user.id).to eq @slave_user.id
          expect(assigns(:form_datum)).to eq @slave_user.form_data.last
        end
      end
    end

    context 'with invalid params' do
      it 'creates a new form_datum missing required field ' do
        expect do
          post :create, { form_datum: FactoryGirl.attributes_for(:form_datum,
                                                                 sections_data: @invalid_data),
                          custom_form_id: @custom_form.id
           }, valid_session
        end.to change(CustomForms::FormDatum, :count).by(0)
      end

      it 'creates a new form_datum empty required field ' do
        expect do
          post :create, { form_datum: FactoryGirl.attributes_for(:form_datum,
                                                                 sections_data: @empty_invalid_data),
                          custom_form_id: @custom_form.id
           }, valid_session
        end.to change(CustomForms::FormDatum, :count).by(0)
      end
    end
  end
end
