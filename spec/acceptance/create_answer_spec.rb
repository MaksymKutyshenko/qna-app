require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to write answers
  to questions
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }
 
  scenario 'Authenticated user creates answers' do    
    sign_in(user)       
    question.save!
    visit questions_path
    click_on('Create answer')
    fill_in 'Body', with: 'Answer textcont'
    click_on 'Create'
    expect(page).to have_content 'Your answer successfully created'    
  end

  scenario 'Non-authenticated user does not create answers' do 
    question.save!
    visit questions_path
    click_on('Create answer')
    expect(page).to have_content 'You need to sign in or sign up before continuing.' 
  end
end
