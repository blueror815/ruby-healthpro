require 'rails_helper'

RSpec.describe "insurance_companies/edit", type: :view do
  before(:each) do
    @insurance_company = assign(:insurance_company, InsuranceCompany.create!(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit insurance_company form" do
    render

    assert_select "form[action=?][method=?]", insurance_company_path(@insurance_company), "post" do

      assert_select "input#insurance_company_name[name=?]", "insurance_company[name]"

      assert_select "input#insurance_company_description[name=?]", "insurance_company[description]"
    end
  end
end
