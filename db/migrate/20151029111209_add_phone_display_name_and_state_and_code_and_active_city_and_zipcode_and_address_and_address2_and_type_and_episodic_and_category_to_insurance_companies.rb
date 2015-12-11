class AddPhoneDisplayNameAndStateAndCodeAndActiveCityAndZipcodeAndAddressAndAddress2AndTypeAndEpisodicAndCategoryToInsuranceCompanies < ActiveRecord::Migration
  def change
    add_column :insurance_companies, :phone, :string
    add_column :insurance_companies, :display_name, :string
    add_column :insurance_companies, :state, :string
    add_column :insurance_companies, :code, :string
    add_column :insurance_companies, :active, :boolean
    add_column :insurance_companies, :city, :string
    add_column :insurance_companies, :zipcode, :string
    add_column :insurance_companies, :address, :string
    add_column :insurance_companies, :address2, :string
    add_column :insurance_companies, :episodic, :string
    add_column :insurance_companies, :category, :string
  end
end
