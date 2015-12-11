require 'rails_helper'

RSpec.describe "insurance_companies/index", type: :view do
  before(:each) do
    assign(:insurance_companies, [
      InsuranceCompany.create!(
        :name => "Name",
        :description => "Description"
      ),
      InsuranceCompany.create!(
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of insurance_companies" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
