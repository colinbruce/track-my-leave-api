FactoryGirl.define do
  factory :user do
    email 'test@email.com'
    password_digest '123456789'
  end
end
