require_relative 'acceptance_helper'

feature 'Questions list', %q{
  As an user I want to be able to 
  watch a list of questions created by users
}do 
  
  given!(:questions) { create_list(:question, 3) }

  scenario 'Any user can watch a list of questions' do 
    visit questions_path
    expect(page).to have_content 'Questions:'
    questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.body
    end
  end
end
