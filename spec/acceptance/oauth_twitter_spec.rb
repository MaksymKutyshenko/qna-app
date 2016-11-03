require_relative 'acceptance_helper'

feature 'Twitter authorization', %q{
  As a user I would like
  to be able to use my twitter account
  to authenticate on website  
} do 

  describe 'sign in with Twitter' do
    it 'confirms user email' do
      visit new_user_session_path
      
      mock_auth_hash(:twitter, info: {})
      click_link "Sign in with Twitter"
      fill_in :email, with: 'some@email.com'
      click_button 'Confirm'
      expect(page).to have_content 'Confirmation mail was sent to your email address'
      open_email('some@email.com')

      current_email.click_link 'confirm your email'
      expect(page).to have_content 'Authorization complete.'
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      visit new_user_session_path
      click_link "Sign in with Twitter"
      page.should have_content('Could not authenticate you from Twitter because "Invalid credentials".')
    end
  end
end