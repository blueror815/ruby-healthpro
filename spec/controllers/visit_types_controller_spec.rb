require 'rails_helper'

RSpec.describe VisitTypesController, type: :controller do
  let(:valid_attributes) do
    {
      title: 'vsit type ',
      price: '50'
    }
  end

  let(:invalid_attributes_missing_price) do
    {
      title: 'visit_type',
      price: ''
    }
  end

  let(:invalid_attributes_missing_title) do
    {
      title: '',
      price: '50'
    }
  end
  let(:valid_session) { {} }
  
  before do 
    @role = Role.find_by(name: 'admin')
    @role.permissions << Permission.where(action_name: 'manage', object_type: 'VisitType')
    @user_role = FactoryGirl.create(:user_role)
    user = FactoryGirl.create(:user, role_id: @role.id)
    @department = FactoryGirl.create(:department)
    @reimbursement = FactoryGirl.create(:reimbursement, title: 'Inject')
    @visit_type = FactoryGirl.create(:visit_type, department_ids: [@department.id], reimbursement_ids: [@reimbursement.id])
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      visit_types = VisitType.all
      get :index, {}, valid_session
      expect(assigns(:visit_types)).to eq(visit_types)
    end
  end

  describe 'GET #get_dependant_data' do
    it "returns the visit_type's available reimbursements type  " do
      xhr :get, :get_visit_type_dependant_data, { id: @visit_type.to_param }, valid_session
      expect(assigns(:reimbursements).first).to be_a(Reimbursement)
    end

    it "returns the visit_type's available reimbursements right count   " do
      xhr :get, :get_visit_type_dependant_data, { id: @visit_type.to_param }, valid_session
      expect(assigns(:reimbursements).count).to be(2)
    end

    it "returns the visit_type's available reimbursements" do
      xhr :get, :get_visit_type_dependant_data, { id: @visit_type.to_param }, valid_session
      expect(assigns(:reimbursements).first).to eq(@reimbursement)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, { id: @visit_type.to_param }, valid_session
      expect(assigns(:visit_type)).to eq(@visit_type)
    end
  end

  describe 'GET #new' do
    it 'assigns a new visit_type as @visit_type' do
      get :new, {}, valid_session
      expect(assigns(:visit_type)).to be_a_new(VisitType)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested visit_type as @visit_type' do
      visit_type = @visit_type
      get :edit, { id: visit_type.to_param }, valid_session
      expect(assigns(:visit_type)).to eq(visit_type)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new VisitType' do
        expect do
          post :create, { visit_type: valid_attributes }, valid_session
        end.to change(VisitType, :count).by(1)
      end

      it 'assigns a newly created visit_type as @visit_type' do
        post :create, { visit_type: valid_attributes }, valid_session
        expect(assigns(:visit_type)).to be_a(VisitType)
        expect(assigns(:visit_type)).to be_persisted
      end

      it 'redirects to the created visit_type' do
        post :create, { visit_type: valid_attributes }, valid_session
        expect(response).to redirect_to(visit_types_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved visit_type as @visit_type missing title' do
        post :create, { visit_type: invalid_attributes_missing_price }, valid_session
        expect(assigns(:visit_type)).to be_a_new(VisitType)
        expect(assigns(:visit_type).errors.full_messages.first).to eq('Price can\'t be blank')
      end

      it 'assigns a newly created but unsaved visit_type as @visit_type missing price' do
        post :create, { visit_type: invalid_attributes_missing_title }, valid_session
        expect(assigns(:visit_type)).to be_a_new(VisitType)
        expect(assigns(:visit_type).errors.full_messages.first).to eq('Title can\'t be blank')
      end

      it "re-renders the 'new' template" do
        post :create, { visit_type: invalid_attributes_missing_price }, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  feature 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { title: 'updated test visit_type',
          price: 50 }
      end

      it 'assigns the requested visit_type as @visit_type' do
        visit_type = @visit_type
        put :update, { id: visit_type.to_param, visit_type: new_attributes }, valid_session
        expect(assigns(:visit_type)).to eq(visit_type)
      end

      it 'assigns the requested visit_type as @visit_type title' do
        visit_type = @visit_type
        put :update, { id: visit_type.to_param, visit_type: new_attributes }, valid_session
        expect(assigns(:visit_type).title).to eq('updated test visit_type')
      end

      it 'redirects to the visit_types' do
        visit_type = @visit_type
        put :update, { id: visit_type.id, visit_type: new_attributes }, valid_session
        expect(response).to redirect_to(visit_types_path)
      end
    end

    context 'with invalid params' do
      let(:new_invalid_attributes) do
        { title: '',
          price: '' }
      end
      it 'assigns the visit_type as @visit_type' do
        visit_type = @visit_type
        put :update, { id: visit_type.to_param, visit_type: new_invalid_attributes }, valid_session
        expect(assigns(:visit_type)).to eq(visit_type)
      end

      it "re-renders the 'edit' template" do
        visit_type = @visit_type
        put :update, { id: visit_type.to_param, visit_type: new_invalid_attributes }, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested visit_type' do
      visit_type = FactoryGirl.create(:visit_type_without_job_type_or_department)
      expect do
        delete :destroy, { id: visit_type.to_param }, valid_session
      end.to change(VisitType, :count).by(-1)
    end

    it 'redirects to the roles list' do
      visit_type = @visit_type
      delete :destroy, { id: visit_type.to_param }, valid_session
      expect(response).to redirect_to(visit_types_url)
    end
  end
end
