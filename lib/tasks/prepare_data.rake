task prepare_data: [:environment] do
  Rake::Task[:add_payment_to_users].invoke
  Rake::Task[:task_type_payment_preparation].invoke
end
