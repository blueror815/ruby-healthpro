require 'rails_helper'

RSpec.describe 'reimbursements/index', type: :view do
  before(:each) do
    assign(:reimbursements, [
      Reimbursement.create!(
        title: 'Title',
        value_type: 1,
        price: 50.to_i
      ),
      Reimbursement.create!(
        title: 'Title',
        value_type: 1,
        price: 50.to_i
      )
    ])
  end

  it 'renders a list of reimbursements' do
    render
    # assert_select ".fa.fa-clock-o.text-primary", text: "Title".to_s, count: 2
    # assert_select "tr>td", text: 1.to_s, count: 2
    # assert_select "tr>td", text: "9.99".to_s, count: 2
  end
end
