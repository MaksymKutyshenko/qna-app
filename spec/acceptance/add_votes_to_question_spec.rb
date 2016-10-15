require_relative 'acceptance_helper'

feature 'Add vote to question', %q{
  As an authorized user I would like to be able to 
  rate question
} do

  given!(:user) { create(:user) }
  given!(:some_user) { create(:user) }
  given!(:question) { create(:question) }
  
  describe 'Authorized user' do 
    before do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'is trying to encrease rating', js: true do 
      within '.question' do
        expect(page).to have_content 'Rating is 0'
        click_link 'Vote up'          
        expect(page).to have_content 'Rating is 1'
      end
    end

    scenario 'is trying to decrease rating', js: true do 
      within '.question' do
        expect(page).to have_content 'Rating is 0'
        click_link 'Vote down'          
        expect(page).to have_content 'Rating is -1'          
      end
    end

    scenario 'is trying to encrease his rating', js: true do
      question.update(user: user)
      within '.question' do
        click_link 'Vote up'
        expect(page).to have_content 'Rating is 0'
      end
      expect(page).to have_content 'You can not rate your own question'
    end

    scenario 'is trying to rate question two times', js: true do
      within '.question' do
        click_link 'Vote up'
        expect(page).to_not have_content 'Vote up'
        expect(page).to_not have_content 'Vote down'
        expect(page).to have_content 'Unvote'
      end
    end

    scenario 'is trying to rate rated by another user', js: true do
      question.rate(some_user, 1)
      within '.question' do
        click_link 'Vote up'
      end
      expect(page).to have_content 'Rating is 2'
    end

    scenario 'is trying to remove his rating from question', js: true do 
      question.rate(user, 1)
      visit question_path(question)
      expect(page).to have_content 'Rating is 1'

      within '.question' do 
        click_link 'Unvote'
        expect(page).to have_content 'Rating is 0'
      end
    end
  end

  describe 'Non-authorized user' do 
    before { visit question_path(question) }

    scenario 'can see question rating' do 
      within '.question' do  
        expect(page).to have_content 'Rating is 0'
      end
    end

    scenario 'is trying to encrease question rating' do 
      within '.question' do  
        expect(page).to_not have_link 'Vote up'
      end
    end

    scenario 'is trying to decrease question rating' do 
      within '.question' do 
        expect(page).to_not have_link 'Vote down' 
      end
    end

    scenario 'is trying to unrate question' do 
      within '.question' do 
        expect(page).to_not have_link 'Unvote'
      end
    end
  end
end