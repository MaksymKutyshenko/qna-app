FactoryGirl.define do
  factory :comment do
    sequence(:body) { |n| "Comment - #{n}" }
    user
  end
end
