require 'rails_helper'

RSpec.describe Visit, type: :model do
  describe '#init_progress_state' do
    it 'should set progress state to unassigned' do
      @visit = FactoryGirl.create(:visit, assignee: nil, progress_state: nil)
      expect(@visit.progress_state).to eq('unassigned')
    end

    it 'should set progress state to assigned' do
      @visit = FactoryGirl.create(:visit, progress_state: nil)
      expect(@visit.progress_state).to eq('assigned')
    end
  end

  describe 'visit assignee' do
    before do
      @visit = FactoryGirl.create(:visit)
    end

    it 'visit should have many job_types' do
      expect(@visit).to respond_to(:assignee)
    end

    it 'visit get the right job_type' do
      expect(@visit.assignee).to be_a(User)
    end
  end

  describe 'visit assigner' do
    before do
      @visit = FactoryGirl.create(:visit)
    end

    it 'visit should have many assigners' do
      expect(@visit).to respond_to(:assigner)
    end

    it 'visit get assigners object' do
      expect(@visit.assigner).to be_a(User)
    end
  end

  describe 'visit patient  ' do
    before do
      @visit = FactoryGirl.create(:visit)
    end

    it 'visit should have many patients' do
      expect(@visit).to respond_to(:patient)
    end

    it 'visit get departments object' do
      expect(@visit.patient).to be_a(Patient)
    end
  end

  describe 'visit visit_type  ' do
    before do
      @visit = FactoryGirl.create(:visit)
    end

    it 'visit should have many patients' do
      expect(@visit).to respond_to(:visit_type)
    end

    it 'visit get departments object' do
      expect(@visit.visit_type).to be_a(VisitType)
    end
  end

  describe 'visit reimbursement type  ' do
    before do
      @visit = FactoryGirl.create(:visit)
    end

    it 'visit should have many patients' do
      expect(@visit).to respond_to(:reimbursements)
    end

    it 'visit get departments object' do
      expect(@visit.reimbursements.last).to be_a(Reimbursement)
    end
  end
  describe 'validate progress' do
    scenario "invalid value type "do 
      @visit = FactoryGirl.build(:visit, progress_state: "some_invalid_values")
      expect(@visit.valid?).to be(false)
    end
    scenario "invalid value type "do 
      @visit = FactoryGirl.build(:visit, progress_state: Visit::PROGRESS_STATE.last)
      expect(@visit.valid?).to be(true)
    end
  end

  describe 'scrape visits from devearo' do
    it 'test ::run_visits_scraper' do
      VCR.use_cassette 'Visit/scrape_visits' do
        # expect{Visit.run_visits_scraper}.to change(Visit, :count)
      end
    end
  end
end
