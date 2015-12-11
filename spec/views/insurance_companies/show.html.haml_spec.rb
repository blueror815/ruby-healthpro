require 'rails_helper'

RSpec.describe "insurance_companies/show", type: :view do
  before(:each) do
    @insurance_company = assign(:insurance_company, InsuranceCompany.create!(
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
  end
end
