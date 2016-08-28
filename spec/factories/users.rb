FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :user_with_questions, class: 'User' do
    email
    password '12345678'
    password_confirmation '12345678'

    transient do
      questions_count 2
    end
    after(:create) do |user, evaluator|
      create_list(:question, evaluator.questions_count, user: user)
    end
  end
end
