require 'rails_helper'

RSpec.describe "availabilities/edit", type: :view do
  before(:each) do
    @availability = assign(:availability, Availability.create!(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit availability form" do
    render

    assert_select "form[action=?][method=?]", availability_path(@availability), "post" do

      assert_select "input#availability_name[name=?]", "availability[name]"

      assert_select "input#availability_description[name=?]", "availability[description]"
    end
  end
end
