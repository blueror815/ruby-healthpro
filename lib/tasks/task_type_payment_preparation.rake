task task_type_payment_preparation: [:environment] do

  h1 = HourType.where(title: "Office Hours", price_factor:1).first_or_create
  job_type_ids = JobType.all.map(&:id)
  HourType.all.each do |vt|
    vt.job_type_ids = job_type_ids
    vt.save
  end

  r1 = Reimbursement.where(title: "Complex Visit", price: 10, value_type: 1).first_or_create.id
  r2 = Reimbursement.where(title: "Out of Area", price: 10, value_type: 1).first_or_create.id
  r3 = Reimbursement.where(title: "Mileage", price: 0.56, value_type: 2).first_or_create.id

  job_type_ids = JobType.all.map(&:id)
  VisitType.all.each do |vt|
    vt.reimbursement_ids = [r1, r2, r3]
    vt.job_type_ids = job_type_ids
    vt.save
  end
end
