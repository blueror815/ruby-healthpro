require 'rails_helper'

RSpec.describe 'visit_types/show.html.haml', type: :view do
  before(:each) do
    @visit_type = assign(:visit_type, FactoryGirl.create(:visit_type, title: 'visit type1'))
  end

  it 'renders visit type title' do
    render
    expect(rendered).to match /visit type1/
  end
end
