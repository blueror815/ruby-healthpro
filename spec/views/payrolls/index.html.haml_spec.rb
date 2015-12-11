require 'rails_helper'

RSpec.describe 'payrolls/index', type: :view do
  before(:each) do
    assign(:payrolls, [
      Payroll.create!(start_date: (Time.now - 4.weeks),end_date: (Time.now - 2.weeks), submission_date: Time.now + 2.weeks + 2.days, admission_date: Time.now + 2.weeks + 3.days),
      Payroll.create!(start_date: (Time.now - 1.day),end_date: (Time.now + 2.weeks), submission_date: Time.now + 2.weeks + 2.days, admission_date: Time.now + 2.weeks + 3.days)
    ])
  end

  it 'renders a list of payrolls' do
    render
  end
end
