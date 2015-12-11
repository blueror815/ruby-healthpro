require 'rails_helper'

RSpec.describe 'visit_types/new.html.haml', type: :view do
  before(:each) do
    assign(:visit_type, VisitType.new)
  end

  it 'renders new visit_type form' do
    render
  end
end
