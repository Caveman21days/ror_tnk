FactoryBot.define do
  factory :comment do
    user_id 1
    commentable_id 1
    commentable_type "MyString"
  end
end
