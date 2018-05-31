class SearchController < ApplicationController
  authorize_resource class: Search

  def index
    respond_with @search_results = Search.search(params[:q], params[:object])
  end
end