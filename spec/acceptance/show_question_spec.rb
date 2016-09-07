require 'rails_helper'

feature 'Show question', %q{
  As and user I want to view a question 
  and a list of answers for it 
} do 

  given!(:question) { create(:question_with_answers) }

  scenario 'User can view a question' do    
    visit question_path(question)    
    expect(page).to have_content question.title 
    expect(page).to have_content question.body 
  end

  scenario 'User can view a list of answers to a given question' do
    visit question_path(question)
    question.answers.each do |a|
      expect(page).to have_content a.body 
    end
  end
end
