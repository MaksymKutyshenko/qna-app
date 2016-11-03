require_relative 'acceptance_helper'

feature 'Auth with facebook', %q{
  As a user I would like
  to be able to use my facebook account
  to authenticate on website  
}do
    
  describe 'sign in with facebook' do
    it 'authenticate user' do
      visit new_user_session_path
      mock_auth_hash(:facebook, info: {email: 'some@email.com'})
      click_link "Sign in with Facebook"
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit new_user_session_path
      click_link "Sign in with Facebook"
      expect(page).to have_content('Could not authenticate you from Facebook because "Invalid credentials".')
    end
  end

end