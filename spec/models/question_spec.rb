require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }
  it { should have_many :votes }
  it { should have_many(:subscribes) }


  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe 'Voting' do
    let!(:votable_object) { create(:question) }
    it_behaves_like 'Votable'
  end
end