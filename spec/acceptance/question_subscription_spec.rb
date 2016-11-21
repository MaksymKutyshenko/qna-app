require_relative 'acceptance_helper'

feature 'Question subscribe', %q{
  As an authenticated user I'd like to
  be able to subscribe to question
  to get mail about new answer to this
  question.
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user subscribes', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
    expect(page).to have_content 'You have successfully subscribed for question'
  end

  scenario 'Authenticated user unsubscribes', js: true do
    sign_in(user)
    user.subscribe(question)
    visit question_path(question)

    within '.question' do
      click_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
    expect(page).to have_content 'You have successfully unsubscribed for question'
  end

  scenario 'Non-authenticated user tries to subscribe', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end
end
