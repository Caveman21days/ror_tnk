require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:authorizations) }
  it { should have_many(:subscribes) }


  describe '#author_of?' do
    let(:user_with_answer) { create(:user_with_answer) }
    let(:user_with_question) { create(:user_with_question) }
    let(:user) { create(:user) }
    let(:question_with_answers) { create(:question_answers) }
    let(:answer) { question_with_answers.answers.first }

    it 'When user is not owner of answer its falsey' do
      expect(user.author_of?(answer)).to be_falsey
    end

    it 'When user is owner of answer its truthy' do
      expect(user_with_answer.author_of?(user_with_answer.answers.first)).to be_truthy
    end

    it 'When user is not owner of question its falsey' do
      expect(user.author_of?(question_with_answers)).to be_falsey
    end

    it 'When user is owner of question its truthy' do
      expect(user_with_question.author_of?(user_with_question.questions.first)).to be_truthy
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user, confirmed_at: DateTime.now) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: user.email }) }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123123')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123123', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123123', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates new authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end


  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end