require 'rails_helper'

RSpec.describe 'payrolls/edit', type: :view do
  before(:each) do
    @payroll = assign(:payroll, Payroll.create!(start_date: Time.now - 1.day, end_date: Time.now + 2.weeks, submission_date: Time.now + 2.weeks + 2.days, admission_date: Time.now + 2.weeks + 3.days))
  end

  it 'renders the edit payroll form' do
    render
    assert_select 'form[action=?][method=?]', payroll_path(@payroll), 'post' do
    end
  end
end
