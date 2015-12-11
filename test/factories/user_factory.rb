# FactoryGirl.define do
#   factory :admin, class: User do
#     email "admin@prohealth.com"
#     password 'secretpass'
#     password_confirmation {|u| u.password}
#     created_at Time.now
#     role_id Role.role_is_a('admin').try(:id)
#   end
#   factory :user, class: User do
#     email "admin@prohealth.com"
#     password 'secretpass'
#     password_confirmation {|u| u.password}
#     created_at Time.now
#     role_id Role.role_is_a('user').try(:id)
#   end
#   factory :hr, class: User do
#     email "hr@prohealth.com"
#     password 'secretpass'
#     password_confirmation {|u| u.password}
#     created_at Time.now
#     role_id Role.role_is_a('hr').try(:id)
#   end
# end
