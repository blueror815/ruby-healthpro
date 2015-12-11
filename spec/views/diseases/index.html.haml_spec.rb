require 'rails_helper'

RSpec.describe 'diseases/index', type: :view do
  before(:each) do
    assign(:diseases, [
      Disease.create!(
        name: 'Name'
      ),
      Disease.create!(
        name: 'Name'
      )
    ])
  end

  it 'renders a list of diseases' do
    render
    # assert_select "tr>td", text: "Name".to_s, count: 2
  end
end
