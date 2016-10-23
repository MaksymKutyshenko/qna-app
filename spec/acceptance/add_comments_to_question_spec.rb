require_relative 'acceptance_helper'

feature 'Add comments', %q{
  As a registerd user
  I would like to be able
  to add comments to question
}do
 
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do 
    before { sign_in(user) }

    scenario 'adds comment to question', js: true do 
      visit question_path(question)
      within '.question .comments' do 
        fill_in 'Comment text', with: 'Question comment'
        click_on 'Add comment'
        expect(page).to have_content 'Question comment'
      end
      expect(page).to have_content 'Your comment cussessfully created'
    end

    scenario 'adds comment to question with wrong params', js: true do 
      visit question_path(question)
      within '.question .comments' do 
        fill_in 'Comment text', with: ''
        click_on 'Add comment'
        expect(page).to_not have_css '.comment'
      end
      expect(page).to have_content 'Body can\'t be blank'
    end 
  end

  describe 'Non-authenticated user' do 
    scenario 'adds comment to question', js: true do 
      visit question_path(question)
      within '.question .comments' do 
        expect(page).to_not have_css '.new_comment'
      end
    end 
  end
end