require 'rails_helper'

RSpec.describe "reimbursement_timesheets/show", type: :view do
  before(:each) do
    @reimbursement_timesheet = assign(:reimbursement_timesheet, ReimbursementTimesheet.create!(
      :reimbursement_id => 1,
      :timesheet_id => 2,
      :progress_state => "Progress State",
      :action_count => 3,
      :comment => "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Progress State/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Comment/)
  end
end
