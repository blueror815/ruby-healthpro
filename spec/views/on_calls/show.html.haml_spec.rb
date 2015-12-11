require 'rails_helper'

RSpec.describe "on_calls/show", type: :view do
  before(:each) do
    @on_call = assign(:on_call, OnCall.create!(
      :note => "Note"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Note/)
  end
end
