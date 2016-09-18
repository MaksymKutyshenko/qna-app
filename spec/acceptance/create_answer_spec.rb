require_relative 'acceptance_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to write answers
  to questions
} do 

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
 
  scenario 'Authenticated user creates answers', js: true do    
    sign_in(user)       
    visit question_path(question)
    fill_in 'Your answer', with: 'Answer text'
    click_on('Create answer')
    expect(page).to have_content 'Your answer successfully created'    
    within '.answers' do 
      expect(page).to have_content 'Answer text'    
    end
  end  

  scenario 'Authenticated user tries to create answer with blank params', js: true do 
    sign_in(user)    
    visit question_path(question)
    fill_in 'Your answer', with: ''
    click_on('Create answer')
    expect(page).to have_content 'Body can\'t be blank'
    within '.answers' do 
      expect(page).to_not have_css '.answer' 
    end
  end

  scenario 'User can see system messages', js: true do 
    sign_in(user)       
    visit question_path(question)
    fill_in 'Your answer', with: ''
    click_on('Create answer')
    expect(page).to have_content 'Body can\'t be blank'    
  end

  scenario 'Non-authenticated user does not create answers', js: true do 
    visit question_path(question)
    expect(page).to_not have_button 'Create answer'
  end
end
