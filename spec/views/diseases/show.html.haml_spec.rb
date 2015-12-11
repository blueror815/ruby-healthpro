require 'rails_helper'

RSpec.describe 'diseases/show', type: :view do
  before(:each) do
    @disease = assign(:disease, Disease.create!(
                                  name: 'Name'
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
