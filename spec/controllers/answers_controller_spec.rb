require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question_answers) }
  let(:answer) { question.answers[0] }

  describe "GET #index" do
    let(:answers) { question.answers }

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers to the current question' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'render question show view' do
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    before { get :show, params: { question_id: question, id: answer } }

    it 'renders answer.question show view' do
      expect(response).to render_template :show
    end

    it 'assigns answers to @answers' do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end


  describe 'POST #create' do
    let(:answers) { question.answers }

    context 'with valid attributes' do
      it 'should saves new @question.answer in the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_answers_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'doesnt saves new question in the db' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(answers, :count)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end
end
