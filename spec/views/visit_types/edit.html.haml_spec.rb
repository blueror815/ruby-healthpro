require 'rails_helper'

RSpec.describe 'visit_types/edit.html.haml', type: :view do
  before(:each) do
    @visit_type = assign(:visit_type, FactoryGirl.create(:visit_type))
  end

  it 'renders the edit visit_type form' do
    render
  end
end
