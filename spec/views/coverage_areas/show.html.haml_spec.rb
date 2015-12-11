require 'rails_helper'

RSpec.describe 'coverage_areas/show', type: :view do
  before(:each) do
    @coverage_area = assign(:coverage_area, CoverageArea.create!(
                                              name: 'Name'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
