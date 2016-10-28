require_relative 'acceptance_helper'

feature 'Delete question attachment', %q{
  As a question owner I would like to
  be able to delete attachments of my question
} do 
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:attachment) { create(:attachment, attachable: question) }

  describe 'Authenticated user' do
    before do 
      sign_in(user)
    end

    scenario 'is trying to delete his question attachment', js: true do 
      question.update(user: user)
      visit question_path(question)
      
      within '.question' do 
        click_link 'Delete file'
      end

      expect(page).to have_content 'Attachment was successfully destroyed.'
      expect(page).to_not have_link attachment.file.filename
    end

    scenario 'is trying to delete not his question attachment', js: true do 
      visit question_path(question)

      within '.question' do 
        expect(page).to_not have_link 'Delete file'
      end      
    end
  end

  describe 'Non-authenticated user' do
    scenario 'is trying to delete question attachment', js: true do 
      visit question_path(question)
      within '.question' do 
        expect(page).to_not have_link 'Delete file'
      end     
    end
  end

end