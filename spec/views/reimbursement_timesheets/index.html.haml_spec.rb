require 'rails_helper'

RSpec.describe "reimbursement_timesheets/index", type: :view do
  before(:each) do
    assign(:reimbursement_timesheets, [
      ReimbursementTimesheet.create!(
        :reimbursement_id => 1,
        :timesheet_id => 2,
        :progress_state => "Progress State",
        :action_count => 3,
        :comment => "Comment"
      ),
      ReimbursementTimesheet.create!(
        :reimbursement_id => 1,
        :timesheet_id => 2,
        :progress_state => "Progress State",
        :action_count => 3,
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of reimbursement_timesheets" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Progress State".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
