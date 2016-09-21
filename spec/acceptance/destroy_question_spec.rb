require_relative 'acceptance_helper'

feature 'User deletes question', %q{
  As an owner of a question I want to
  be able to delete it.
}do 
  
  given(:user) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user is trying to delete his question' do
    sign_in(user)
    visit question_path(question)
    click_link 'Delete'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(page).to have_content 'Your question has been successfully deleted!'
  end

  scenario 'Authenticated user is trying to delete not his question' do
    sign_in(some_user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user is trying to delete question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end
end
