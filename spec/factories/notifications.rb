FactoryGirl.define do
  factory :notification do
    sender_id 1
receiver_id ""
notifiable_id 1
notifiable_type "MyString"
  end

end
