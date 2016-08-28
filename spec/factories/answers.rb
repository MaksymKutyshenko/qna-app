FactoryGirl.define do
  sequence :body do |n|
    "Answer text - #{n}"
  end

  factory :answer do
    body
    user
  end 

  factory :invalid_answer, class: Answer do 
    body nil
    user nil
  end
end
