shared_examples_for "Voted" do
  context 'user can vote for object' do
    sign_in_user

    it 'adds vote to object' do
      do_request
      expect(response.status).to eq(200)
    end

    it 'change count of object votes' do
      expect { do_request }.to change(object.votes, :count).by(1)
    end
  end

  context 'user can not vote for object' do
    it 'try to vote for object' do
      do_request
      expect(response.body).to include('You need to sign in or sign up before continuing')
      expect(response.status).to eq(401)
    end
  end
end