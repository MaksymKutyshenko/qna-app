require_relative 'acceptance_helper.rb'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of Question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:some_question) { create(:question) }

  describe 'Authenticated user' do 
    before do 
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'sees link Edit' do
      expect(page).to have_link 'Edit'
    end

    scenario 'tries to edit his question', js: true do
      within '.question' do 
        click_on 'Edit'
        fill_in 'Title', with: 'New title'
        fill_in 'Question text', with: 'New text'
        
        click_on 'Save'
        expect(page).to have_content 'New title'
        expect(page).to have_content 'New text'
        expect(page).to_not have_selector '.edit_question'
      end
      expect(page).to have_content 'Your question has been successfully updated'
    end

   scenario 'tries to edit other user\'s question' do 
      visit question_path(some_question)      
      within '.question' do  
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'tries to edit his question with invalid params', js: true do 
      visit question_path(question)

      within '.question' do 
        click_on 'Edit'

        fill_in 'Title', with: ''
        fill_in 'Question text', with: ''
        click_on 'Save'
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
      expect(page).to have_content "Title can't be blank and Body can't be blank"
    end
  end

  describe 'Non-authenticated user' do
    scenario 'tries to edit answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end