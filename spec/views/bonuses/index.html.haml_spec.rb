require 'rails_helper'

RSpec.describe "bonuses/index", type: :view do
  before(:each) do
    assign(:bonuses, [
      Bonuse.create!(
        :user_id => 1,
        :price => "Price",
        :timesheet_id => 2
      ),
      Bonuse.create!(
        :user_id => 1,
        :price => "Price",
        :timesheet_id => 2
      )
    ])
  end

  it "renders a list of bonuses" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Price".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
