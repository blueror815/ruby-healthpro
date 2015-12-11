require 'rails_helper'

RSpec.describe "payments/new", type: :view do
  before(:each) do
    assign(:payment, Payment.new(
      :amount => "9.99",
      :notes => "MyString",
      :patient_id => 1
    ))
  end

  it "renders new payment form" do
    render

    assert_select "form[action=?][method=?]", payments_path, "post" do

      assert_select "input#payment_amount[name=?]", "payment[amount]"

      assert_select "input#payment_notes[name=?]", "payment[notes]"

      assert_select "input#payment_patient_id[name=?]", "payment[patient_id]"
    end
  end
end
