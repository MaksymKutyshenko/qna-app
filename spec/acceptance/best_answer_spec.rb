require_relative 'acceptance_helper'

feature 'Best answer', %q{
  As an owner of a question 
  I would like to be able to 
  choose the best answer to my question
} do 

  given(:user) { create(:user) }
  given(:some_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:best_answer) { create(:answer, best: true, question: question) }

  describe 'Authenticated user' do 
    scenario 'is trying to choose best answer to his question', js: true do 
      sign_in(user)
      visit question_path(question)
      
      within ".answer-#{answer.id}" do 
        click_link 'Best'
      end

      expect(page).to have_content 'Best answer chosen'
    end

    scenario 'is trying to choose already chosen best answer' do 
      sign_in(user)
      visit question_path(question)
      
      within ".answer-#{best_answer.id}" do 
        expect(page).to_not have_link 'Best'
      end
    end

    scenario 'sees best answer on top of all answers' do 
      sign_in(user)
      answer.best!
      visit question_path(question)

      within ".answers" do 
        expect(page).to have_css(".answer:first-child", :text => answer.body)
      end
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