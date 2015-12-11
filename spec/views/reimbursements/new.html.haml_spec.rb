require 'rails_helper'

RSpec.describe 'reimbursements/new', type: :view do
  before(:each) do
    assign(:reimbursement, Reimbursement.new(
                             title: 'MyString',
                             value_type: 1,
                             price: '9.99'
    ))
  end

  it 'renders new reimbursement form' do
  end
end
