require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answers from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do    
    sign_in(user)    
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Question text', with: 'text text'
    click_on 'Create'
    expect(page).to have_content 'Question was successfully created'    
    expect(page).to have_content 'Test question'    
    expect(page).to have_content 'text text'    
  end

  scenario 'Authenticated user tries to create question with blank params' do 
    sign_in(user)    
    visit questions_path
    click_on 'Ask question'    
    fill_in 'Title', with: ''
    fill_in 'Question text', with: ''
    click_on 'Create'
    expect(page).to have_content 'Title can\'t be blank and Body can\'t be blank'
  end

  context 'multiple sessions', js: true do 
    scenario 'questions appears on another user\'s page' do     
      Capybara.using_session('user') do 
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do 
        visit questions_path        
      end

      Capybara.using_session('user') do 
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Question text', with: 'text text'
        click_on 'Create'
        expect(page).to have_content 'Question was successfully created'    
        expect(page).to have_content 'Test question'    
        expect(page).to have_content 'text text'            
      end

      Capybara.using_session('guest') do 
        expect(page).to have_content 'Test question' 
      end
    end
  end

  scenario 'Non-authenticated user tries to create question' do 
    visit questions_path
    click_on 'Ask question'    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
