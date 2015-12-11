require 'rails_helper'

RSpec.describe 'payrolls/new', type: :view do
  before(:each) do
    assign(:payroll, Payroll.new)
  end

  it 'renders new payroll form' do
    render

    assert_select 'form[action=?][method=?]', payrolls_path, 'post' do
    end
  end
end
