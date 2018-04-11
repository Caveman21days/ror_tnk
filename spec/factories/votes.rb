FactoryBot.define do
  factory :vote do
    votable_id 1
    votable_type "MyString"
    vote false
  end
end
