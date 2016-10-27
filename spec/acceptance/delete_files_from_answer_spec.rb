require_relative 'acceptance_helper'

feature 'Delete files', %q{
  As an author of a question
  I would like to be able to 
  delete attached files
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  describe 'Authenticated user' do
    before do 
       sign_in(user)
    end

    scenario 'trying to delete attached file from his answer', js: true do 
      answer.update(user: user)
      visit question_path(question)

      within '.answers' do 
        click_link 'Delete file'
      end

      expect(page).to have_content 'Attachment was successfully destroyed.'
      expect(page).to_not have_link attachment.file.filename
    end

    scenario 'trying to delete attached file from some user\'s answer', js: true do
      visit question_path(question)

      within '.answers' do 
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  describe 'Non-authenticated user' do
    scenario 'trying to delete attached file from some user\'s answer', js: true do 
      visit question_path(question)
      within '.answers' do 
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
end