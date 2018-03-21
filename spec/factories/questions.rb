
FactoryBot.define do

  sequence :title do |n|
    "title_#{n}"
  end

  factory :invalid_question, class: "Question" do
    user
    title nil
    body nil
  end

  factory :question do
    user
    title
    body "MyText"

    factory :question_answers do
      transient do
        answers_count 2
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end
