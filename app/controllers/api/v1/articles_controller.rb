class Api::V1::ArticlesController < Api::V1::BaseController
  def index
    @city_name = "Vailate"

    @location_data = Geocode.new(@city_name).call
    @list_of_sorted_cities = Geonames.new(@location_data, "app/services/countries.json", "app/services/languages.json").call

    @results = Rails.cache.fetch("articles-#{@list_of_sorted_cities}", expires_in: 2.hours) do
      Webhose.new(@list_of_sorted_cities).call
    end
  end

  def update
    Rails.logger.debug
    @location_data = params[:coordinates]
    # @list_of_sorted_cities = Geonames.new(@location_data, "app/services/countries.json", "app/services/languages.json").bounding_box_search(@location_data, 5)
  end
end
