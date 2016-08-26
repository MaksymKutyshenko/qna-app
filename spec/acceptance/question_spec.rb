require 'rails_helper'

feature 'Question', %q{
  As and user I want to view a question 
  and a list of answers for it 
} do 

  given(:question) { create(:question_with_answers) }

  scenario 'User can view a question and a list of answers for it' do    
    visit question_path(question)    
    expect(page).to have_content 'Question title' 
    expect(page).to have_content 'Question body' 
    expect(page).to have_content 'Answer text'
  end
end
