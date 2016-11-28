require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.find' do
    it 'returns an array' do
      expect(Search.find(query: 'Some search query', classes: [Answer, Question])).to be_kind_of(Array)
    end
  end

  describe '.search_classes' do
    it 'returns an array' do
      expect(Search.search_classes).to be_kind_of(Array)
    end
  end

  describe '.constantize_classes' do
    it 'returns an array of classes' do
      expect(Search.send(
        'constantize_classes',
        ["User", "Answer", "Question", "Comment"])
      ).to match_array([User, Answer, Question, Comment])
    end

    it 'returns only valid search classes' do
      expect(Search.send(
        'constantize_classes',
        ['Answer', 'InvalidClassName', 'Question'])
      ).to match_array([Answer, Question])
    end
  end
end
