require 'rails_helper'

RSpec.describe "claim_types/new", type: :view do
  before(:each) do
    assign(:claim_type, ClaimType.new(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new claim_type form" do
    render

    assert_select "form[action=?][method=?]", claim_types_path, "post" do

      assert_select "input#claim_type_name[name=?]", "claim_type[name]"

      assert_select "input#claim_type_description[name=?]", "claim_type[description]"
    end
  end
end
