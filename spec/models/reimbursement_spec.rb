require 'rails_helper'

RSpec.describe Reimbursement, type: :model do
  context 'value_type validation' do
    scenario 'invalid value type 'do
      @remb = FactoryGirl.build(:reimbursement, value_type: 5)
      expect(@remb.valid?).to be(false)
    end

    scenario 'invalid value type 'do
      @remb = FactoryGirl.build(:reimbursement, value_type: Reimbursement::TYPES.keys.last)
      expect(@remb.valid?).to be(true)
    end
  end
end
