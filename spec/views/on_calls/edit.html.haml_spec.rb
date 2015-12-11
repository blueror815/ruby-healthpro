require 'rails_helper'

RSpec.describe "on_calls/edit", type: :view do
  before(:each) do
    @on_call = assign(:on_call, OnCall.create!(
      :note => "MyString"
    ))
  end

  it "renders the edit on_call form" do
    render

    assert_select "form[action=?][method=?]", on_call_path(@on_call), "post" do

      assert_select "input#on_call_note[name=?]", "on_call[note]"
    end
  end
end
