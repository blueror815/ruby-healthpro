require 'rails_helper'

RSpec.describe "bonuses/edit", type: :view do
  before(:each) do
    @bonuse = assign(:bonuse, Bonuse.create!(
      :user_id => 1,
      :price => "MyString",
      :timesheet_id => 1
    ))
  end

  it "renders the edit bonuse form" do
    render

    assert_select "form[action=?][method=?]", bonuse_path(@bonuse), "post" do

      assert_select "input#bonuse_user_id[name=?]", "bonuse[user_id]"

      assert_select "input#bonuse_price[name=?]", "bonuse[price]"

      assert_select "input#bonuse_timesheet_id[name=?]", "bonuse[timesheet_id]"
    end
  end
end
