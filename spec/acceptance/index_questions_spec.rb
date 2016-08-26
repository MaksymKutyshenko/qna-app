require 'rails_helper'

feature 'Questions list', %q{
  As an user I want to be able to 
  watch a list of questions created by users
}do 
  
  scenario 'Any user can watch a list of questions' do 
    visit questions_path
    expect(page).to have_content 'Questions:'
  end
end
