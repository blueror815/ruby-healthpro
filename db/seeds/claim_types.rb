claim_types = ['ADR', 'Final', 'Hospice', 'Hospice R&B', 'LUPA', 'RAP', 'RAP TB REBILL']
claim_types.each do |claim_type|
  ClaimType.find_or_create_by(name: claim_type)
end