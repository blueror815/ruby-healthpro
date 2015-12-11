insurance_types = ["Medicare", "Alam County Med", "Alameda Alliance", "Blue Cross", "Blue Shield", "CareCentrix", "CHCN", "HealthNet", "HP San Mateo", "Kaiser Comm.", "Kaiser Sen. Med. Adv.", "MediCal", "PAVA", "SFVA", "United", "Medical"]
insurance_types.each do |insurance_type|
  InsuranceCompany.find_or_create_by(name: insurance_type)
end