require 'rails_helper'

RSpec.describe "bills/edit", type: :view do
  before(:each) do
    @bill = assign(:bill, Bill.create!(
      :amount => "9.99",
      :patient_id => 1
    ))
  end

  it "renders the edit bill form" do
    render

    assert_select "form[action=?][method=?]", bill_path(@bill), "post" do

      assert_select "input#bill_amount[name=?]", "bill[amount]"

      assert_select "input#bill_patient_id[name=?]", "bill[patient_id]"
    end
  end
end
