task scrape_insurance_companies: [:environment] do
  InsuranceCompany.scrape_insurance_companies
end
