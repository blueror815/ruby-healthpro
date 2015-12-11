require 'rails_helper'

RSpec.describe 'payrolls/show', type: :view do
  before(:each) do
    @payroll = assign(:payroll, Payroll.create!(start_date: (Time.now - 1.day), end_date: (Time.now + 2.weeks), submission_date: Time.now + 2.weeks + 2.days, admission_date: Time.now + 2.weeks + 3.days))
  end

  it 'renders attributes in <p>' do
    # render
  end
end
