require 'rails_helper'

RSpec.describe 'reimbursements/edit', type: :view do
  before(:each) do
    @reimbursement = assign(:reimbursement, Reimbursement.create!(
                                              title: 'MyString',
                                              value_type: 1,
                                              price: '9.99'
    ))
  end

  it 'renders the edit reimbursement form' do
  end
end
