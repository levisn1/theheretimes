class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    api = ApplicationRecord.api(params)
    @city_name = api[:city_name]
    @list_of_sorted_cities = api[:list_of_sorted_cities]
    @results = api[:articles]
  end
end
