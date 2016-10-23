require_relative 'acceptance_helper'

feature 'Add comments', %q{
  As a registerd user
  I would like to be able
  to add comments to question
}do
 
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do 
    scenario 'adds comment to question', js: true do 
      visit question_path(question)
      within '.question .comments' do 
        fill_in 'Comment text', with: 'Question comment'
        click_on 'Add comment'
        expect(page).to have_content 'Question comment'
      end
    end 
  end
end