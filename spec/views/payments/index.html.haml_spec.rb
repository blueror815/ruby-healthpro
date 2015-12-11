require 'rails_helper'

RSpec.describe "payments/index", type: :view do
  before(:each) do
    assign(:payments, [
      Payment.create!(
        :amount => "9.99",
        :notes => "Notes",
        :patient_id => 1
      ),
      Payment.create!(
        :amount => "9.99",
        :notes => "Notes",
        :patient_id => 1
      )
    ])
  end

  it "renders a list of payments" do
    render
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Notes".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
