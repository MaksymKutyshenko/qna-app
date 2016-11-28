class SearchController < ApplicationController
  authorize_resource

  def index
    respond_with @results = Search.find(params)
  end
end
