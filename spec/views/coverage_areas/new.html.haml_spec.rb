require 'rails_helper'

RSpec.describe 'coverage_areas/new', type: :view do
  before(:each) do
    assign(:coverage_area, CoverageArea.new(
                             name: 'MyString'
    ))
  end

  it 'renders new coverage_area form' do
    render

  end
end
