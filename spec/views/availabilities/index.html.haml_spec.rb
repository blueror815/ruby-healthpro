require 'rails_helper'

RSpec.describe "availabilities/index", type: :view do
  before(:each) do
    assign(:availabilities, [
      Availability.create!(
        :name => "Name",
        :description => "Description"
      ),
      Availability.create!(
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of availabilities" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
