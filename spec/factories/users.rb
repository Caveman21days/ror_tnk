FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password '123123123'
    password_confirmation '123123123'

    factory :user_with_answer, class: 'User' do
      after(:create) do |user|
        create(:answer, user: user)
      end
    end

    factory :user_with_question, class: 'User' do
      after(:create) do |user|
        create(:question, user: user)
      end
    end
  end
end
