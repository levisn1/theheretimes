class ArticlesController < ApplicationController
  def index
    city_name = "macugnaga"


    @location_data = Geocode.new(city_name).call
    @list_of_sorted_cities = Geonames.new(@location_data, "app/services/countries.json", "app/services/languages.json").call
    @markers = @list_of_sorted_cities.map do |city|
      {
        lat: city[:latitude],
        lng: city[:longitude],
      }
    end
    @results = Webhose.new(@list_of_sorted_cities).call
  end
end
