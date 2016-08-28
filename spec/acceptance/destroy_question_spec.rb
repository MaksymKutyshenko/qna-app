require 'rails_helper'

feature 'User deletes question', %q{
  As an owner of a question I want to
  be able to delete it.
}do 
  
  given(:user) { create(:user_with_questions) }
  given(:question) { create(:question) }

  scenario 'Authenticated user is trying to delete his question' do
    sign_in(user)
    visit question_path(user.questions.first)
    click_link 'Delete'
    expect(page).to have_content 'Your question has been successfully deleted!'
  end

  scenario 'Non-authenticated user is trying to delete question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
