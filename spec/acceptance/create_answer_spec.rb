require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to write answers
  to questions
} do 

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
 
  scenario 'Authenticated user creates answers' do    
    sign_in(user)       
    visit question_path(question)
    fill_in 'Body', with: 'Answer text'
    click_on('Create answer')
    expect(page).to have_content 'Your answer successfully created'    
    expect(page).to have_content 'Answer text'    
  end

  scenario 'User can see system messages' do 
    sign_in(user)       
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on('Create answer')
    expect(page).to have_content 'Body can\'t be blank'    
  end

  scenario 'Non-authenticated user does not create answers' do 
    visit question_path(question)
    expect(page).to_not have_button 'Create answer'
  end
end
