require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do
  let(:question) { create(:question) }

  describe "DELETE #destroy" do
    let!(:subscribe) { create(:subscribe, question: question) }

    subject { delete :destroy, params: { id: subscribe.id, format: :js } }


    describe "Authorized user" do
      sign_in_user

      context "has subscribe" do
        before { subscribe.update(user_id: @user.id) }

        it "can unsubscribe to question" do
          expect { subject }.to change(question.subscribes, :count).by(-1)
        end

        it "render template destroy" do
          subject
          expect(response).to render_template :destroy
        end
      end

      context "user has not subscribtion" do
        it "can not unsubscribe" do
          expect { subject }.to_not change(question.subscribes, :count)
        end
      end
    end

    describe "Unauthorized user" do
      it "can not subscribe question" do
        expect { subject }.to_not change(question.subscribes, :count)
      end

      it "get 403 status Unauthorized" do
        subject
        expect(response.status).to eq 403
      end
    end
  end


  describe "POST #create" do
    subject { post :create, params: { question_id: question.id, format: :js } }

    describe "Authorized user" do
      sign_in_user

      it "subscribe to question" do
        expect { subject }.to change(@user.subscribes, :count).by(1)
      end

      it "can not subscribe to question when already has subscribtion" do
        @user.subscribes.create(question_id: question.id)
        expect { subject }.to_not change(@user.subscribes, :count)
      end

      it "render template create" do
        subject
        expect(response).to render_template :create
      end
    end

    describe "Unauthorized user" do
      it "can not subscribe question" do
        expect { subject }.to_not change(question.subscribes, :count)
      end

      it "get 403 status unauthorized" do
        subject
        expect(response.status).to eq 403
      end
    end
  end
end