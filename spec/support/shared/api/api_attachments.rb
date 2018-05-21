shared_examples_for "API attachments" do
  context 'attachments' do
    it "object contains attachments -> url" do
      expect(response.body).to be_json_eql(object.send('attachments'.to_sym).first.file.url.to_json).at_path('attachments/0/url')
    end
  end
end