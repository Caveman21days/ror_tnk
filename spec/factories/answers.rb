FactoryBot.define do

  sequence :body do |n|
    "MyAnswer_#{n}"
  end

  factory :answer do
    question
    body
    user
  end

  factory :invalid_answer, class: Answer do
    question
    body nil
    user
  end
end
