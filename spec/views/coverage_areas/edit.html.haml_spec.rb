require 'rails_helper'

RSpec.describe 'coverage_areas/edit', type: :view do
  before(:each) do
    @coverage_area = assign(:coverage_area, CoverageArea.create!(
                                              name: 'MyString'
    ))
  end

  it 'renders the edit coverage_area form' do
    render

  end
end
