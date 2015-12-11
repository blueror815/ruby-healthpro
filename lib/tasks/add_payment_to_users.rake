task add_payment_to_users: [:environment] do
  User.all.each do |user|
    puts "///////////", user.id
    user.create_payment_rates
  end
end
