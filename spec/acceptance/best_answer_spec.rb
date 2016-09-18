require_relative 'acceptance_helper'

feature 'Best answer', %q{
  As an owner of a question 
  I would like to be able to 
  choose the best answer to my question
} do 

  given(:user) { create(:user) }
  given(:some_user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user) }

  describe 'Authenticated user' do 
    scenario 'is trying to choose best answer to his question', js: true do 
      sign_in(user)
      visit question_path(question)
      
      within ".answer-#{question.answers.first.id}" do 
        click_link 'Best'
        expect(page).to_not have_link 'Best'
      end

      expect(page).to have_content 'Best answer chosen'
    end

    scenario 'is trying to choose best answer not to his question' do 
      sign_in(some_user)
      visit question_path(question)

      expect(page).to_not have_link 'Best'
    end
  end

  describe 'Non-authenticated user' do 
    scenario 'is trying to choose best answer to question', js: true do 
      visit question_path(question)
      expect(page).to_not have_link 'Best'
    end
  end
end