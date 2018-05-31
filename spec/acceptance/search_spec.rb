require 'sphinx_acceptance_helper'

feature 'Search' do
  given!(:user_search)     { create(:user, email: 'searched@example.com') }
  given!(:question_search) { create(:question, body: 'question that will be searched') }
  given!(:answer_search)   { create(:answer, body: 'answer that will be searched') }
  given!(:comment_search)  { Comment.create(commentable_id: question_search.id, commentable_type: "Question", body: 'comment that will be searched', user: user_search) }

  given!(:user_not_search)     { create(:user, email: 'simply_user@example.com') }
  given!(:question_not_search) { create(:question, body: 'simply question') }
  given!(:answer_not_search)   { create(:answer, body: 'simply answer') }
  given!(:comment_not_search)  { Comment.create(commentable_id: question_not_search.id, commentable_type: "Question", body: 'simply comment', user: user_not_search) }


  background do
    index
    visit(root_path)
    fill_in 'q', with: "searched"
  end

  scenario 'search without filters', :js do
    click_button "Search"

    within ".searches-list" do
      expect(page).to have_content question_search.title
      expect(page).to have_content "Found a match in the answer for the question #{answer_search.question.title}"
      expect(page).to have_content "Found in question #{comment_search.commentable.title}"
      expect(page).to have_content user_search.email

      expect(page).to_not have_content question_not_search.title
      expect(page).to_not have_content "Found a match in the answer for the question #{answer_not_search.question.title}"
      expect(page).to_not have_content "Found in question #{comment_not_search.commentable.title}"
      expect(page).to_not have_content user_not_search.email
    end
  end

  scenario 'search with question filter', :js do
    select "Questions", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to have_content question_search.title
      expect(page).to_not have_content "Found a match in the answer for the question #{answer_search.question.title}"
      expect(page).to_not have_content "Found in question #{comment_search.commentable.title}"
      expect(page).to_not have_content user_search.email
    end
  end


  scenario 'search with answer filter', :js do
    select "Answers", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to_not have_content question_search.title
      expect(page).to have_content "Found a match in the answer for the question #{answer_search.question.title}"
      expect(page).to_not have_content "Found in question #{comment_search.commentable.title}"
      expect(page).to_not have_content user_search.email
    end
  end

  scenario 'search with comment filter', :js do
    select "Comments", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to have_content question_search.title
      expect(page).to_not have_content "Found a match in the answer for the question #{answer_search.question.title}"
      expect(page).to have_content "Found in question #{comment_search.commentable.title}"
      expect(page).to_not have_content user_search.email
    end
  end

  scenario 'search with author filter', :js do
    select "Author", from: "object"
    click_button "Search"

    within ".searches-list" do
      expect(page).to_not have_content question_search.title
      expect(page).to_not have_content "Found a match in the answer for the question #{answer_search.question.title}"
      expect(page).to_not have_content "Found in question #{comment_search.commentable.title}"
      expect(page).to have_content user_search.email
    end
  end

end