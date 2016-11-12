require 'rails_helper'

describe 'Questions API' do
  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:answers) { create_list(:answer, 2, question: question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token in invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(attachments comments answers).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to have_json_size(2).at_path(attr)
        end
      end

      it 'contains attachment with url' do
        expect(response.body).to be_json_eql(attachments.first.file.url.to_json).at_path("attachments/1/url")
      end
    end
  end

  describe 'GET /' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

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
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns status 401' do
        post '/api/v1/questions', params: { question: attributes_for(:question) }
        expect(response.status).to eq 401
      end

      it 'returns status 401 when access_token is invalid' do
        post '/api/v1/questions', params: { question: attributes_for(:question), access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
  end

  context 'authorized' do
    let!(:access_token) { create(:access_token) }

    context 'when question params are valid' do
      before { post '/api/v1/questions', params: { format: :json, question: attributes_for(:question), access_token: access_token.token } }

      it 'returns status 200' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(assigns(:question).send(attr).to_json).at_path(attr)
        end
      end
    end

    context 'when question params are invalid' do
      before { post '/api/v1/questions', params: { format: :json, question: attributes_for(:invalid_question), access_token: access_token.token } }

      it 'returns status 422' do
        expect(response.status).to eq 422
      end
    end
  end
end
