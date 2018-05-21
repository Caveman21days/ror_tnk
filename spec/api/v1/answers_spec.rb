require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }

    it_behaves_like "API Authenticable"


    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2) }
      let(:answer) { answers.first }
      let!(:question) { answers.first.question }
      # let!(:answer) { create(:answer, question: question) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body user_id question_id created_at updated_at the_best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end


  describe 'GET /show' do
    let!(:answer) { create(:answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response).to have_http_status 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response).to have_http_status 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { Comment.create(commentable: answer, user: create(:user)) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:object) { answer }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns answer' do
        expect(response.body).to include_json("#{answer.id}")
      end

      %w(id body user_id question_id created_at updated_at the_best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      it_behaves_like "API attachments"
    end
  end


  describe 'POST /create' do
    let!(:question) { create(:question) }

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid answer params' do

        before { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: access_token.token } }

        it 'returns 201 status code' do
          expect(response).to have_http_status 201
        end

        it 'returns created answer' do
          expect(response.body).to have_json_path('/')
        end

        %w(body).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(Answer.last.send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end

      context 'with invalid answer params' do
        before { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:invalid_answer), access_token: access_token.token } }

        it "returns 422 status code" do
          expect(response).to have_http_status 422
        end

        it 'returns errors list' do
          expect(response.body).to have_json_size(1).at_path('errors')
        end

        %w(body).each do |attr|
          it "returns #{attr} presence error" do
            expect(response.body).to be_json_eql("can't be blank".to_json).at_path("errors/#{attr}/0")
          end
        end
      end
    end
  end



  def do_request(options = {})
    get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
  end

end