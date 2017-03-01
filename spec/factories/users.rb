FactoryGirl.define do
  factory :user do
    email 'test@email.com'
    password_digest BCrypt::Password.create('password').to_s

    factory :confirmed_user do
      confirmation_token nil
      confirmed_at Time.zone.now
    end
  end
end
