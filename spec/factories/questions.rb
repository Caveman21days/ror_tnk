FactoryBot.define do
  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

  factory :question do
    title "MyString"
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
