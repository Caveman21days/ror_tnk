require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }



  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    sign_in_user
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    # it 'builds new attachments for answer' do
    #   expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    # end

    it 'assigns the new answer for question' do
      expect(assigns(:answer )).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    # По сути билдить ничего не надо, теперь это делает гем
    # it 'builds new Attachment for @question' do
    #   expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    # end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'should saves new question in the db' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'user of question should be eq to signed user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'doesnt saves new question in the db' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:user_with_questions) { create_list(:question, 2, user: @user) }

    context 'user try to detele his own question' do
      it 'should delete author`s question' do
        user_with_questions
        expect { delete :destroy, params: { id: user_with_questions.first } }.to change(Question, :count).by(-1)
      end

      it 'redirects to question index view' do
        delete :destroy, params: { id: user_with_questions.first }
        expect(response).to redirect_to questions_path
      end
    end

    context 'another user can delete question' do
      it 'should not delete user`s question' do
        question
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end


  describe 'PATCH #update' do
    sign_in_user
    let(:question) { create(:question, user: @user) }
    let(:question2) { create(:question) }

    context 'user try to edit his own question' do
      it 'should update answer' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, params: { id: question, question: attributes_for(:question), question: { body: 'new body' }, format: :js }
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'render update question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template 'questions/update'
      end

    end

    context 'another user try update question' do
      it 'should not update answer' do
        patch :update, params: { id: question2, question: attributes_for(:question), format: :js }
        expect(response).to render_template 'questions/update'
      end
    end
  end
end
