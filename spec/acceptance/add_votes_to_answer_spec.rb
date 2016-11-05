require_relative 'acceptance_helper'

feature 'Add votes to answer', %q{
  As an authorized user I would like to be able to 
  rate answers
} do 

  given!(:user) { create(:user) }
  given!(:some_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authorized user' do 
    before do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'is trying to encrease rating', js: true do 
      within '.answer' do
        expect(page).to have_content 'Rating is 0'
        click_link 'Vote up'          
        expect(page).to have_content 'Rating is 1'
      end
    end

    scenario 'is trying to decrease rating of answer', js: true do 
      within '.answer' do 
        expect(page).to have_content 'Rating is 0'
        click_link 'Vote down'
        expect(page).to have_content 'Rating is -1'
      end
    end

    scenario 'is trying to change rating of his answer', js: true do 
      answer.update(user: user)
      within '.answer' do 
        click_link 'Vote down'
        expect(page).to have_content 'Rating is 0'
      end
      expect(page).to have_content 'You have no rights to perform this action'
    end

    scenario 'is trying to rate answer two times', js: true do 
      within '.answer' do 
        click_link 'Vote up'
        expect(page).to_not have_content 'Vote up'
        expect(page).to_not have_content 'Vote down'
        expect(page).to have_content 'Unvote'
      end
    end

    scenario 'is trying to rate answer rated by other user', js: true do 
      answer.rate(some_user, 1)
      within '.answer' do 
        click_link 'Vote up'
        expect(page).to have_content 'Rating is 2'
      end
    end
  end

  describe 'Non-authorized user' do 
    before { visit question_path(question) }

    scenario 'can see answer rating' do 
      within '.answer' do  
        expect(page).to have_content 'Rating is 0'
      end
    end

    scenario 'is trying to encrease answer rating' do 
      within '.answers' do  
        expect(page).to_not have_link 'Vote up'
      end
    end

    scenario 'is trying to decrease answer rating' do 
      within '.answers' do 
        expect(page).to_not have_link 'Vote down' 
      end
    end

    scenario 'is trying to unrate answer' do 
      within '.answers' do 
        expect(page).to_not have_link 'Unvote'
      end
    end
  end
end