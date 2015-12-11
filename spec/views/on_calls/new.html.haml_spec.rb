require 'rails_helper'

RSpec.describe "on_calls/new", type: :view do
  before(:each) do
    assign(:on_call, OnCall.new(
      :note => "MyString"
    ))
  end

  it "renders new on_call form" do
    render

    assert_select "form[action=?][method=?]", on_calls_path, "post" do

      assert_select "input#on_call_note[name=?]", "on_call[note]"
    end
  end
end
