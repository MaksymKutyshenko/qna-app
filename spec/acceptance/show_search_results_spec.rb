require_relative 'acceptance_helper'

feature 'Show search results', %q{
  As a user, I would like to find
  resources that I am interrested in
} do

  given!(:user) { create(:user, email: 'some@user.com') }
  given!(:question) { create(:question, body: 'Some question') }
  given!(:answer) { create(:answer, question: question, body: 'Some answer') }
  given!(:comment) { create(:comment, commentable: question, body: 'Some comment') }

  before { visit questions_path }

  %w(question answer comment).each do |resource|
    scenario "User searches in context of #{resource}", sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: "Some #{resource}"
        find(:css, "##{resource.classify}").set(true)
        click_button 'Search'
        expect(page).to have_content("Some #{resource}")
      end
    end
  end

  scenario 'User searches in user context', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'some@user.com'
      find(:css, "#User").set(true)
      click_button 'Search'
      expect(page).to have_content('some@user.com')
    end
  end

  scenario 'User searches in any context that contains "Some" text', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'Some'
      click_button 'Search'
      expect(page).to have_css('.search-result', count: 4)
    end
  end
end
