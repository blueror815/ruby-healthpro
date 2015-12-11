require 'rails_helper'

RSpec.describe "claim_types/index", type: :view do
  before(:each) do
    assign(:claim_types, [
      ClaimType.create!(
        :name => "Name",
        :description => "Description"
      ),
      ClaimType.create!(
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of claim_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
