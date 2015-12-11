require 'rails_helper'

RSpec.feature JobTypesController, type: :controller do
  let(:valid_session) { {} }

  before do
    @role = Role.find_by(name: 'admin')
    @job_type = FactoryGirl.create(:simple_job_type)
    @user = FactoryGirl.create(:user, role_id: @role.id)
    sign_in(@user)
  end

  describe 'DELETE #destroy' do
    context 'with assigned users' do
      it 'destroys the requested job stops ' do
        FactoryGirl.create(:user, email: 'another_user@prohealth.com', role_id: @role.id, job_type_id: @job_type.id)
        expect do
          delete :destroy, { id: @job_type.id }, valid_session
        end.to_not change(JobType, :count)
      end
    end

    context 'without assigned users ' do
      it 'destroys the requested job' do
        FactoryGirl.create(:simple_job_type, job_class: 'another job')
        expect do
          delete :destroy, { id: @job_type.id }, valid_session
        end.to change(JobType, :count).by(-1)
      end
    end
  end
end
