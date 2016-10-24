require_relative 'acceptance_helper'

feature 'Add comments', %q{
  As a registerd user
  I would like to be able
  to add comments to answer
}do
 
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer_without_comments) { create(:answer, question: question) }
  given!(:answer_with_comments) { create(:answer, question: question) }
  given!(:comment1) { create(:comment, user: user, commentable: answer_with_comments) }
  given!(:comment2) { create(:comment, user: user, commentable: answer_with_comments) }

  describe 'Authenticated user' do 
    before { sign_in(user) }

    scenario 'adds comment to answer', js: true do 
      visit question_path(question)

      within ".answer-#{answer_without_comments.id} .comments" do 
        fill_in 'Comment text', with: 'Answer comment'
        click_on 'Add comment'
        expect(page).to have_content 'Answer comment'
      end
      expect(page).to have_content 'Your comment cussessfully created'
    end

    scenario 'adds comment to answer with wrong params', js: true do 
      visit question_path(question)
      within ".answer-#{answer_without_comments.id} .comments" do 
        fill_in 'Comment text', with: ''
        click_on 'Add comment'
        expect(page).to_not have_css '.comment'
      end
      expect(page).to have_content 'Body can\'t be blank'
    end 
  end

  describe 'Non-authenticated user' do 
    scenario 'adds comment to answer', js: true do 
      visit question_path(question)
      within ".answer-#{answer_without_comments.id} .comments" do 
        expect(page).to_not have_css '.new_comment'
      end
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
        within ".answer-#{answer_without_comments.id} .comments" do 
          fill_in 'Comment text', with: 'Answer comment'
          click_on 'Add comment'
          expect(page).to have_content 'Answer comment'
        end
        expect(page).to have_content 'Your comment cussessfully created'          
      end
    end

    scenario 'answers appear on another user\'s page', js: true do 
      Capybara.using_session('guest') do 
        within ".answer-#{answer_without_comments.id} .comments" do
          expect(page).to have_content 'Answer comment'         
        end
      end
    end

    scenario 'answer apears only on it\'s question page', js: true do 
      Capybara.using_session('guest2') do       
        within ".answers" do
          expect(page).to_not have_content 'Answer comment' 
        end
      end
    end 
  end

  scenario 'user can see a list of created comments' do 
    answer_with_comments.update(question: question)
    visit question_path(question)

    within ".answer-#{answer_with_comments.id} .comments" do 
      expect(page).to have_content comment1.body
      expect(page).to have_content comment2.body
    end
  end
end