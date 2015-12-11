require 'rails_helper'

RSpec.describe "insurance_companies/new", type: :view do
  before(:each) do
    assign(:insurance_company, InsuranceCompany.new(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new insurance_company form" do
    render

    assert_select "form[action=?][method=?]", insurance_companies_path, "post" do

      assert_select "input#insurance_company_name[name=?]", "insurance_company[name]"

      assert_select "input#insurance_company_description[name=?]", "insurance_company[description]"
    end
  end
end
