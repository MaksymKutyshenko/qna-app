require_relative 'acceptance_helper'

feature 'User sign up', %q{
  As a user I want to be able 
  to sign up to ask questions
  and create answers
} do

    scenario 'User is trying to sign up using not existing user data' do
      visit new_user_registration_path
      fill_in 'Email', with: 'some@email.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(page).to_not have_content 'Sign in'      
      expect(page).to_not have_content 'Sign up'      
      expect(page).to have_content 'Sign out'
    end

    given(:user) { create(:user) }

    scenario 'User is trying to sign up using existing user data' do
      visit new_user_registration_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
      click_button 'Sign up'
      expect(page).to have_content 'Email has already been taken'
    end
end
