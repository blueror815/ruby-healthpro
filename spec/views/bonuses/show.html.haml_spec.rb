require 'rails_helper'

RSpec.describe "bonuses/show", type: :view do
  before(:each) do
    @bonuse = assign(:bonuse, Bonuse.create!(
      :user_id => 1,
      :price => "Price",
      :timesheet_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Price/)
    expect(rendered).to match(/2/)
  end
end
