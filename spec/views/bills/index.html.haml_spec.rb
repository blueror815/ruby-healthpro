require 'rails_helper'

RSpec.describe "bills/index", type: :view do
  before(:each) do
    assign(:bills, [
      Bill.create!(
        :amount => "9.99",
        :patient_id => 1
      ),
      Bill.create!(
        :amount => "9.99",
        :patient_id => 1
      )
    ])
  end

  it "renders a list of bills" do
    render
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
