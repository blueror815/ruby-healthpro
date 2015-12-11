require 'rails_helper'

RSpec.describe "claim_types/edit", type: :view do
  before(:each) do
    @claim_type = assign(:claim_type, ClaimType.create!(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit claim_type form" do
    render

    assert_select "form[action=?][method=?]", claim_type_path(@claim_type), "post" do

      assert_select "input#claim_type_name[name=?]", "claim_type[name]"

      assert_select "input#claim_type_description[name=?]", "claim_type[description]"
    end
  end
end
