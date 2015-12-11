require 'rails_helper'

RSpec.describe "claim_types/show", type: :view do
  before(:each) do
    @claim_type = assign(:claim_type, ClaimType.create!(
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
  end
end
