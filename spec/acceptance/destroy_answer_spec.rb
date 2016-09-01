require 'rails_helper'

feature 'User deletes answer', %q{
  An a user I want to be able to
  delete my own answers
}do 
  
  given(:user) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user is trying to delete his answer' do 
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_content 'Answer has been successfully deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'Non-authenticated user is trying to delete not his answer' do     
    sign_in(some_user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end
end
