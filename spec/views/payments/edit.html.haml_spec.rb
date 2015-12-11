require 'rails_helper'

RSpec.describe "payments/edit", type: :view do
  before(:each) do
    @payment = assign(:payment, Payment.create!(
      :amount => "9.99",
      :notes => "MyString",
      :patient_id => 1
    ))
  end

  it "renders the edit payment form" do
    render

    assert_select "form[action=?][method=?]", payment_path(@payment), "post" do

      assert_select "input#payment_amount[name=?]", "payment[amount]"

      assert_select "input#payment_notes[name=?]", "payment[notes]"

      assert_select "input#payment_patient_id[name=?]", "payment[patient_id]"
    end
  end
end
