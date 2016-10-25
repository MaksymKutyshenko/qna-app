require_relative 'acceptance_helper'

feature 'Add comments', %q{
  As a registerd user
  I would like to be able
  to add comments to question
}do
 
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question_with_comments) { create(:question) }
  given!(:comment1) { create(:comment, user: user, commentable: question_with_comments) }
  given!(:comment2) { create(:comment, user: user, commentable: question_with_comments) }

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

  scenario 'user can see a list of created comments' do 
    visit question_path(question_with_comments)

    within '.question .comments' do 
      expect(page).to have_content comment1.body
      expect(page).to have_content comment2.body
    end
  end

  given!(:question2) { create(:question) }

  describe 'Multiple sessions' do 
    before do 
      Capybara.using_session('user') do 
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do 
        visit question_path(question)      
      end

      Capybara.using_session('guest2') do 
        visit question_path(question2)
      end

      Capybara.using_session('user') do 
        visit question_path(question)
        within '.question .comments' do 
          fill_in 'Comment text', with: 'Question comment'
          click_on 'Add comment'
          expect(page).to have_content 'Question comment'
        end
        expect(page).to have_content 'Your comment cussessfully created'          
      end
    end

    scenario 'answers appear on another user\'s page', js: true do 
      Capybara.using_session('guest') do 
        within '.question .comments' do
          expect(page).to have_content 'Question comment'         
        end
      end
    end

    scenario 'answer apears only on it\'s question page', js: true do 
      Capybara.using_session('guest2') do       
        within '.question .comments' do
          expect(page).to_not have_content 'Question comment' 
        end
      end
    end 
  end
end