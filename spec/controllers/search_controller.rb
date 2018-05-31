require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #index" do
    subject { get :index, params: { q: "test", object: "" } }

    it "call search method" do
      expect(Search).to receive(:search).with("test", "")
      subject
    end

    it "render index view" do
      subject
      expect(response).to render_template :index
    end
  end
end