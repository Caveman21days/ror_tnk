require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_answers) }
  let(:answer) { question.answers.first }

  describe 'GET #index' do
    let(:answers) { question.answers }

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers to the current question' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'render question show view' do
      expect(response).to render_template :index
    end
  end

  # describe 'GET #show' do
  #   before { get :show, params: { question_id: question, id: answer } }
  #
  #   it 'renders answer.question show view' do
  #     expect(response).to render_template :show
  #   end
  #
  #   it 'assigns answers to @answers' do
  #     expect(assigns(:answer)).to eq answer
  #   end
  # end

  # describe 'GET #new' do
  #   sign_in_user
  #
  #   before { get :new, params: { question_id: question } }
  #
  #   it 'assigns a new answer to @answer' do
  #     p answer.id
  #     p subject.current_user
  #     p '================='
  #     p question.answers[0].id
  #     p question.user.id
  #
  #     expect(assigns(:answer)).to be_a_new(Answer)
  #   end
  #
  #   it 'render new view' do
  #     expect(response).to render_template :new
  #   end
  # end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'should saves new @question.answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, user_id: @user.id) } }.to change(question.answers, :count).by(1)
      end
      
      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, user_id: @user.id) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:question_without_answers) { create(:question) }

      it 'doesnt saves new question in the db' do
        expect{ post :create, params: { question_id: question_without_answers, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 'redirects to answer.question show view' do
        post :create, params: { question_id: question_without_answers, answer: attributes_for(:invalid_answer) }
        expect(response).to redirect_to question_path(question_without_answers)
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let(:user_with_answer) { create(:answer, question: question, user: @user) }

    context 'user try to detele his own answer' do
      it 'should delete author`s answer' do
        expect { delete :destroy, params: { question_id: user_with_answer.question, id: user_with_answer.id } }.to change(user_with_answer.question.answers, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { question_id: user_with_answer.question, id: user_with_answer.id }
        expect(response).to redirect_to question_path(user_with_answer.question)
      end
    end

    context 'another user can delete answer' do
      it 'should not delete user`s answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer.id } }.to_not change(question.answers, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { question_id: question.id, id: answer.id }
        expect(response).to have_http_status(204)
      end
    end
  end
end
