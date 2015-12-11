require 'rails_helper'

RSpec.describe "reports/index", type: :view do
  before(:each) do
    assign(:reports, [
      Report.create!(
        :custom_form_id => 1
      ),
      Report.create!(
        :custom_form_id => 1
      )
    ])
  end

  it "renders a list of reports" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
