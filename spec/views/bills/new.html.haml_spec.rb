require 'rails_helper'

RSpec.describe "bills/new", type: :view do
  before(:each) do
    assign(:bill, Bill.new(
      :amount => "9.99",
      :patient_id => 1
    ))
  end

  it "renders new bill form" do
    render

    assert_select "form[action=?][method=?]", bills_path, "post" do

      assert_select "input#bill_amount[name=?]", "bill[amount]"

      assert_select "input#bill_patient_id[name=?]", "bill[patient_id]"
    end
  end
end
