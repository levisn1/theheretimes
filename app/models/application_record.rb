class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.api(params)
    if params[:lat] && params[:lng]
      location_data = ReverseGeocode.new(params).call
    else
      city_name = "Philadelphia"
      location_data = Geocode.new(city_name).call
    end

    list_of_sorted_cities = Geonames.new(location_data, "app/services/countries.json", "app/services/languages.json").call

    cache_key = "#{list_of_sorted_cities.map{|i| i[:name]}.sort.uniq.join}-#{params[:since]}"

    Rails.logger.debug("-----cache_key")
    Rails.logger.debug(cache_key)

    articles = Rails.cache.fetch(cache_key, expires_in: 2.hours) do
      Rails.logger.debug("expires_in")

      Webhose.new(list_of_sorted_cities).call(params[:since])
    end

    {
      city_name: city_name,
      articles: articles,
      list_of_sorted_cities: list_of_sorted_cities,
    }
  end
end
