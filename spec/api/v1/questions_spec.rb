require 'rails_helper'

describe 'Questions API' do
  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let!(:access_token) { create(:access_token) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      %w(attachments comments answers).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to have_json_size(2).at_path(attr)
        end
      end

      it 'contains attachment with url' do
        expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("attachments/1/url")
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /' do
    let(:access_token) { create(:access_token) }
    let!(:questions) { create_list(:question, 2) }
    let!(:question) { questions.first }
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
           expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:access_token) { create(:access_token) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      context 'when question params are valid' do
        %w(id title body created_at updated_at).each do |attr|
          it "question contains #{attr}" do
            post '/api/v1/questions', params: { format: :json, question: attributes_for(:question), access_token: access_token.token }
            expect(response.body).to be_json_eql(assigns(:question).send(attr).to_json).at_path(attr)
          end
        end
      end

      context 'when question params are invalid' do
        it 'returns status 422' do
          post '/api/v1/questions', params: { format: :json, question: attributes_for(:invalid_question), access_token: access_token.token }
          expect(response.status).to eq 422
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json, question: attributes_for(:question) }.merge(options)
    end
  end
end
