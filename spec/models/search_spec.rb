require 'rails_helper'

RSpec.describe Search, type: :model do
  describe ".search" do
    %w(question answer comment user).each do |object|
      it "should call search method for the #{object}" do
        expect(object.classify.constantize).to receive(:search).with("")
        Search.search("", object)
      end
    end

    it "should call search without filters" do
      expect(ThinkingSphinx).to receive(:search).with("")
      Search.search("", "")
    end

    it "not valid value" do
      expect(ThinkingSphinx).to receive(:search).with("")
      Search.search("", "not_valid_value")
    end
  end

  describe ".filters" do
    it "return array" do
      filters = [
        [nil, nil],
        ["Questions", "question"],
        ["Answers", "answer"],
        ["Comments", "comment"],
        ["Author", "user"]
      ]
      expect(Search.filters).to match_array(filters)
    end
  end
end