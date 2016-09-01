FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer text - #{n}" }
    user
  end 

  factory :invalid_answer, class: Answer do 
    body nil
    user nil
  end
end
