require_relative 'acceptance_helper.rb'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of Answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:some_question) { create(:question_with_answers) }

  describe 'Authenticated user' do 
    before do
      sign_in user
      visit question_path(question)      
    end

    scenario 'sees edit link' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end
    
    scenario 'tries to edit his answer', js: true do
      click_on 'Edit'
      
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to have_content 'Answer has been successfully updated'
    end

    scenario 'tries to edit his answer with invalid params', js: true do
      click_on 'Edit'
      
      within '.answers' do
        fill_in 'Answer', with: ''
        click_on 'Save'
        
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Body can't be blank"
    end
  
    scenario 'tries to edit other user\'s answer' do 
      visit question_path(some_question)      
      within '.answers' do  
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'Non-authenticated user' do
    scenario 'tries to edit answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end