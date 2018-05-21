require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_answers) }
  let(:answer) { question.answers.first }


  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'should saves new @question.answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'user of answer should be eq to signed user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'renders create parchel' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid attributes' do
      let(:question_without_answers) { create(:question) }

      it 'does not saves new question in the db' do
        expect{ post :create, params: { question_id: question_without_answers, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 'renders answer.question show view' do
        post :create, params: { question_id: question_without_answers, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template 'answers/create'
      end
    end
  end


  describe 'DELETE #destroy' do
    sign_in_user
    let(:user_with_answer) { create(:answer, question: question, user: @user) }

    context 'user try to delete his own answer' do
      it 'should delete answer' do
        expect { delete :destroy, params: { question_id: user_with_answer.question, id: user_with_answer.id, format: :js } }.to change(user_with_answer.question.answers, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { question_id: user_with_answer.question, id: user_with_answer.id, format: :js }
        expect(response).to render_template 'answers/destroy'
      end
    end

    context 'another user try delete answer' do
      it 'should not delete answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer.id, format: :js } }.to_not change(question.answers, :count)
      end
    end
  end


  describe 'PATCH #update' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: @user) }
    let(:answer2) { create(:answer, question: question) }

    context 'user try to edit his own answer' do
      it 'should update answer' do
        patch :update, params: { question_id: answer.question, id: answer.id, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: answer.question, id: answer.id, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update answer' do
        patch :update, params: { question_id: answer.question, id: answer.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template 'answers/update'
      end

    end

    context 'another user try update answer' do
      it 'should not delete answer' do
        patch :update, params: { question_id: answer2.question, id: answer2.id, answer: attributes_for(:answer), format: :js }
        expect(response).to have_http_status(403)
      end
    end
  end


  describe 'PATCH #set_the_best' do
    sign_in_user
    let(:user_question) { create(:question_answers, user: @user) }

    context 'author of question try to set the best answer' do
      it 'should set the_best option to answer' do
        patch :set_the_best, params: { question_id: user_question, id: user_question.answers.first, format: :js }
        expect(assigns(:answer).the_best).to eq true
      end
    end
  end


  describe 'POST #vote' do
    let(:question) { create(:question) }
    let(:object) { create(:answer, question: question) }

    it_behaves_like "Voted"

    def do_request
      post :vote, params: { question_id: question, id: object, vote: true, format: :json }
    end
  end
end
