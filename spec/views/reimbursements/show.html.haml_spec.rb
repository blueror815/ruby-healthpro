require 'rails_helper'

RSpec.describe 'reimbursements/show', type: :view do
  before(:each) do
    @reimbursement = assign(:reimbursement, Reimbursement.create!(
                                              title: 'Title',
                                              value_type: 1,
                                              price: '9.99'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/9.99/)
  end
end
