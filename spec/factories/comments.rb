FactoryBot.define do
  factory :comment do
    user
    commentable_id
    commentable_type
  end
end
