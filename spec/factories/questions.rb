FactoryGirl.define do
  factory :question do
    title "Question title"
    body "Question body"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end

  factory :question_with_answers, class: 'Question' do
    title "Question title"
    body "Question body"
    transient do
      answers_count 2
    end
    after(:create) do |question, evaluator|
      create_list(:answer, evaluator.answers_count, question: question)
    end
  end
end
