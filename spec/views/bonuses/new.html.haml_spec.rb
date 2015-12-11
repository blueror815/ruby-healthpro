require 'rails_helper'

RSpec.describe "bonuses/new", type: :view do
  before(:each) do
    assign(:bonuse, Bonuse.new(
      :user_id => 1,
      :price => "MyString",
      :timesheet_id => 1
    ))
  end

  it "renders new bonuse form" do
    render

    assert_select "form[action=?][method=?]", bonuses_path, "post" do

      assert_select "input#bonuse_user_id[name=?]", "bonuse[user_id]"

      assert_select "input#bonuse_price[name=?]", "bonuse[price]"

      assert_select "input#bonuse_timesheet_id[name=?]", "bonuse[timesheet_id]"
    end
  end
end
