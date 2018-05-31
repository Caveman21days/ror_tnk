class Search

  def self.search(q, object="all")
    q = ThinkingSphinx::Query.escape(q) if !q.nil?

    if self.available_filters.include?(object)
      object.classify.constantize.search q
    else
      ThinkingSphinx.search q
    end
  end

  def self.filters
    [
      [nil, nil],
      ["Questions", "question"],
      ["Answers", "answer"],
      ["Comments", "comment"],
      ["Author", "user"]
    ]
  end


  private

  def self.available_filters
    %w(question answer comment user)
  end
end