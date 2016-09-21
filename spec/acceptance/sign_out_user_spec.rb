require_relative 'acceptance_helper'

feature 'User logout', %q{
  As a signed up user 
  I want to be able to logout
  for sequre reasons of my account
} do  

  given(:user) { create(:user) }

  scenario 'Signed up user is trying to logout' do 
    sign_in user
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
