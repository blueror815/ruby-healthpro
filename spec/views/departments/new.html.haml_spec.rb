require 'rails_helper'

RSpec.describe 'departments/new', type: :view do
  before(:each) do
    assign(:department, Department.new(
                          name: 'MyString'
    ))
    @model = 'department'
  end

  it 'renders new department form' do
    render
    expect(rendered).to match /MyString/
  end
end
