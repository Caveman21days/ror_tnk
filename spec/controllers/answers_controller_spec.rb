require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_answers) }
  let(:answer) { question.answers.first }


  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'should saves new @question.answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'user of answer should be eq to signed user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:question_without_answers) { create(:question) }

      it 'does not saves new question in the db' do
        expect{ post :create, params: { question_id: question_without_answers, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 'renders answer.question show view' do
        post :create, params: { question_id: question_without_answers, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template 'questions/show'
      end
    end
  end


  describe 'DELETE #destroy' do
    sign_in_user
    let(:user_with_answer) { create(:answer, question: question, user: @user) }

    context 'user try to delete his own answer' do
      it 'should delete answer' do
        expect { delete :destroy, params: { question_id: user_with_answer.question, id: user_with_answer.id } }.to change(user_with_answer.question.answers, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { question_id: user_with_answer.question, id: user_with_answer.id }
        expect(response).to redirect_to question_path(user_with_answer.question)
      end
    end

    context 'another user try delete answer' do
      it 'should not delete answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer.id } }.to_not change(question.answers, :count)
      end

      it 'redirects to log in' do
        delete :destroy, params: { question_id: question.id, id: answer.id }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
