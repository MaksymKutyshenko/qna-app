require_relative 'acceptance_helper.rb'

feature 'Add file to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do 

  given(:user) { create(:user) }

  background do 
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Question text', with: 'Text of question'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end

  scenario 'User adds multiple files when asks question', js: true do 
    fill_in 'Title', with: 'Test question'
    fill_in 'Question text', with: 'Text of question'
      
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_link 'add file'
    within '.nested-fields' do 
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end
      
    click_on 'Create'   
    
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb' 
  end
end