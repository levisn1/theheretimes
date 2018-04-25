class ArticlesController < ApplicationController
  def index
    city_name = "vailate"

    @location_data = Geocode.new(city_name).call
    @list_of_sorted_cities = Geonames.new(@location_data, "app/services/countries.json", "app/services/languages.json").call
    @results = Webhose.new(@list_of_sorted_cities).call
  end
end
