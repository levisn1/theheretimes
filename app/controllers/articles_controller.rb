class ArticlesController < ApplicationController
  def index
    @city_name = "Vailate"

    location_data = Geocode.new(@city_name).call
    @list_of_sorted_cities = Geonames.new(location_data, "app/services/countries.json", "app/services/languages.json").call

    @results = Rails.cache.fetch("articles-#{@list_of_sorted_cities}-#{params[:since]}", expires_in: 2.hours) do
      Webhose.new(@list_of_sorted_cities).call(params[:since])
    end
  end
end







