require 'rails_helper'

RSpec.describe 'departments/edit', type: :view do
  before(:each) do
    @department = assign(:department, Department.create!(
                                        name: 'MyString'
    ))
    @model = 'department'
  end

  it 'renders the edit department form' do
    render
    expect(rendered).to match /MyString/
  end
end
