require 'rails_helper'

RSpec.describe VisitType, type: :model do
  describe 'vist_type job_types' do
    before do
      @visit_type = FactoryGirl.create(:visit_type)
    end

    it 'visit_type should have many job_types' do
      expect(@visit_type).to respond_to(:job_types)
    end

    it 'visit_type get the right job_type' do
      expect(@visit_type.job_types.first).to be_a(JobType)
    end
  end

  describe 'visit_type departments' do
    before do
      @visit_type = FactoryGirl.create(:visit_type)
    end

    it 'visit_type should have many departments' do
      expect(@visit_type).to respond_to(:departments)
    end

    it 'visit_type get departments object' do
      expect(@visit_type.departments.first).to be_a(Department)
    end
  end

  describe 'visit_type Reimbursement  ' do
    before do
      @visit_type = FactoryGirl.create(:visit_type)
    end

    it 'visit_type should have many departments' do
      expect(@visit_type).to respond_to(:reimbursements)
    end

    it 'visit_type get departments object' do
      expect(@visit_type.reimbursements.first).to be_a(Reimbursement)
    end
  end
end
