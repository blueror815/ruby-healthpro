require 'rails_helper'

RSpec.describe "availabilities/show", type: :view do
  before(:each) do
    @availability = assign(:availability, Availability.create!(
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
