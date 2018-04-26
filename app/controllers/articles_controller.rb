class ArticlesController < ApplicationController
  def index

    if params[:lat] && params[:lng]
      @location_data = ReverseGeocode.new(params).call
    else
      @city_name = "Milan"
      @location_data = Geocode.new(@city_name).call
    end

    @list_of_sorted_cities = Geonames.new(@location_data, "app/services/countries.json", "app/services/languages.json").call

    @results = Rails.cache.fetch("articles-#{@list_of_sorted_cities}", expires_in: 2.hours) do
      Webhose.new(@list_of_sorted_cities).call
    end
  end
end
