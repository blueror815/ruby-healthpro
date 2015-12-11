require 'rails_helper'

RSpec.describe "on_calls/index", type: :view do
  before(:each) do
    assign(:on_calls, [
      OnCall.create!(
        :note => "Note"
      ),
      OnCall.create!(
        :note => "Note"
      )
    ])
  end

  it "renders a list of on_calls" do
    render
    assert_select "tr>td", :text => "Note".to_s, :count => 2
  end
end
