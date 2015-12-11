require 'rails_helper'

RSpec.feature PatientsController, type: :controller do
  let(:valid_attributes) do
    {
      display_name: 'patient',
      contact_number: '01010101',
      email: 'patient@prohealth.com',
      agency_id: 4
    }
  end

  let(:invalid_attributes) do
    {

      display_name: '',
      contact_number: '',
      email: ''
    }
  end

  let(:datatable_params) do
    {
      'draw' => '1', 'columns' => {
        '0' => {
          'data' => '0',
          'name' => '',
          'searchable' => 'true',
          'orderable' => 'true',
          'search' => {
            'value' => '',
            'regex' => 'false'
          }
        }, '1' => {
          'data' => '1',
          'name' => '',
          'searchable' => 'true',
          'orderable' => 'true',
          'search' => {
            'value' => '',
            'regex' => 'false'
          }
        }, '2' => {
          'data' => '2',
          'name' => '',
          'searchable' => 'true',
          'orderable' => 'true',
          'search' => {
            'value' => '',
            'regex' => 'false'
          }
        }
      },
      'order' => {
        '0' => {
          'column' => '0',
          'dir' => 'asc'
        }
      },
      'start' => '0',
      'length' => '10',
      'search' => {
        'value' => '',
        'regex' => 'false'
      },
      '_' => '1438798905862'
    }
  end

  let(:valid_session) { {} }

  before do
    @role = Role.find_by(name: 'office_employee')
    @role.permissions << Permission.where(action_name: 'edit', object_type: 'Patient')
    @role.permissions << Permission.where(action_name: 'administrate', object_type: 'Patient')
    @role.permissions << Permission.where(action_name: 'view', object_type: 'Patient')
    @user_role = FactoryGirl.create(:user_role)
    @office_employee = FactoryGirl.create(:user, role_id: @role.id)
    @patient = FactoryGirl.create(:patient, display_name: 'mark')
    @patient_category = FactoryGirl.create(:patient_category, name: 'Patient')
    sign_in(@office_employee)
    request.env['HTTP_REFERER'] = 'where_i_came_from'
  end

  # # patients are retrieved using ajax.
  # describe "GET #index" do
  #   it "assigns all patients as @patients" do
  #     patients = Patient.all.order(display_name: :desc).limit(10)
  #     xhr :get, :index, datatable_params, valid_session
  #     expect(assigns(:patients)).to eq(patients)
  #   end
  # end

  describe 'GET #show' do
    it 'assigns the requested patient as @patient' do
      patient = @patient
      get :show, { id: patient.to_param }, valid_session
      expect(assigns(:patient)).to eq(patient)
    end
  end

  describe 'GET #new' do
    it 'assigns a new patient as @patient' do
      get :new, {}, valid_session
      expect(assigns(:patient)).to be_a_new(Patient)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Patient' do
        expect do
          post :create, { patient: valid_attributes }, valid_session
        end.to change(Patient, :count).by(1)
      end

      it 'assigns a newly created patient as @patient' do
        post :create, { patient: valid_attributes }, valid_session
        expect(assigns(:patient)).to be_a(Patient)
        expect(assigns(:patient)).to be_persisted
      end

      it 'redirects to the created patient' do
        post :create, { patient: valid_attributes }, valid_session
        expect(response).to redirect_to(patients_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved patient as @patient' do
        post :create, { patient: invalid_attributes }, valid_session
        expect(assigns(:patient)).to be_a_new(Patient)
      end

      it "re-renders the 'new' template" do
        post :create, { patient: invalid_attributes }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  feature 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          display_name: 'updated patient',
          contact_number: '01010101',
          email: 'patient@prohealth.com',
          agency_id: 8}
      end

      scenario 'updates the requested patient' do
        patient = @patient
        put :update, { id: patient.to_param, patient: new_attributes }, valid_session
        patient.reload
        expect(assigns(:patient).display_name).to eq('updated patient')
        # page.should have_content('updated patient')
        # skip("Add assertions for updated state")
      end

      it 'assigns the requested patient as @patient' do
        patient = @patient
        put :update, { id: patient.to_param, patient: valid_attributes }, valid_session
        expect(assigns(:patient)).to eq(patient)
      end

      it 'redirects to the patient' do
        patient = @patient
        put :update, { id: patient.id, patient: valid_attributes }, valid_session
        expect(response).to redirect_to(patient_path(patient.id))
      end

      scenario 'updates the requested patient agency'  do
        patient = @patient
        put :update, { id: patient.to_param, patient: new_attributes }, valid_session
        patient.reload
        expect(assigns(:patient).agency_id).to eq(8)
      end
    end

    context 'with invalid params' do
      it 'assigns the patient as @patient' do
        patient = @patient
        put :update, { id: patient.to_param, patient: invalid_attributes }, valid_session
        expect(assigns(:patient)).to eq(patient)
      end

      it "re-renders the 'edit' template" do
        patient = @patient
        put :update, { id: patient.to_param, patient: invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested patient ' do
      patient = @patient
      expect do
        delete :destroy, { id: patient.to_param }, valid_session
      end.to change(Patient, :count).by(-1)
    end

    it 'redirects to the patients list' do
      patient = @patient
      delete :destroy, { id: patient.to_param }, valid_session
      expect(response).to redirect_to(patients_url)
    end
  end

  describe 'Adding forms to patient' do
    before do
      @patient_category = FactoryGirl.create(:patient_category, name: 'Patient')
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
      @custom_form_1 = FactoryGirl.create(:custom_form, title: 'first_custom', permissions: permissions, sections: sections, form_category_id: @patient_category)
      @custom_form_2 = FactoryGirl.create(:custom_form, title: 'second_custom', permissions: permissions, sections: sections, form_category_id: @patient_category)
      data = {
        '0': {
          field_name: 'some_field'
        }
      }
      FactoryGirl.create(:form_datum, custom_form_id: @custom_form_1.id,  sections_data: data, creator_user_id: @office_employee.id)
      FactoryGirl.create(:form_datum, custom_form_id: @custom_form_2.id,  sections_data: data, creator_user_id: @office_employee.id)
    end

    it 'add_form_data_to_patient' do
      put :update, { id: @patient.to_param, patient: valid_attributes,
                     custom_form_ids: [@custom_form_1, @custom_form_2]
        }, valid_session
      expect(assigns(:patient).form_data.map(&:custom_form).uniq.map(&:id)).to eq([@custom_form_1.id, @custom_form_2.id])
    end
  end
end
