require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do

    it 'renders index template' do
      get :index, params: { query: 'Some query' }
      expect(response).to render_template :index
    end

    it 'calls search ThinkingSphinx method' do
      expect(ThinkingSphinx).to receive(:search).with('Some query', classes: [Answer, Question])
      get :index, params: { classes: ['Answer', 'Question'], query: 'Some query' }
    end
  end
end
