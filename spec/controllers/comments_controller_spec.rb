require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    let(:parameters) do
      {
        question_id: question.id,
        format: :json,
        comment: { body: 'test comment' }
      }
    end
    subject { post :create, params: parameters }

    context 'Authorized user' do
      sign_in_user
      context 'with valid data' do
        it 'changes count of questions comments' do
          expect { subject }.to change(question.comments, :count).by(1)
        end
      end

      context 'with invalid data' do
        let(:parameters) do
          {
            question_id: question.id,
            format: :json,
            comment: { body: '' }
          }
        end

        it 'not changes count of questions comments' do
          expect { subject }.to_not change(question.comments, :count)
        end
      end
    end

    context 'Unauthorized user' do
      it 'not changes count of questions comments' do
        expect { subject }.to_not change(question.comments, :count)
      end
    end
  end
end