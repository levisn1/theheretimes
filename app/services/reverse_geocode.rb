require 'net/http'
require 'json'
require 'pry'

class ReverseGeocoding

  GOOGLE_MAPS_GEOCODE_API = "AIzaSyBHf-pI5bEXmml-_C4kOFZKSAuGG9eH1kI"

  def initialize(coordinates)
    @coordinates = coordinates
  end

  def call
    geocode = URI("https://maps.googleapis.com/maps/api/geocode/json?latlng=" + @coordinates[:latitude].to_s + "," + @coordinates[:longitude].to_s + "&key=" + GOOGLE_MAPS_GEOCODE_API)
    geocode_net = Net::HTTP.get_response(geocode)
    geocode_net_json = JSON.parse(geocode_net.body)
    latitude = @coordinates[:latitude]
    longitude = @coordinates[:longitude]

    country_code = ""
    geocode_net_json["results"][0]["address_components"].each do |short_name|
      short_name["types"].each do |short_name_types|
        if short_name_types == "country"
          country_code = short_name["short_name"]
        end
      end
    end

    city_name = ""
    geocode_net_json["results"][0]["address_components"].each do |short_name|
      short_name["types"].each do |short_name_types|
        if short_name_types == "locality"
          city_name = short_name["short_name"]
        end
      end
    end

    location_data = {
      longitude: longitude,
      latitude: latitude,
      country_code: country_code,
      city_name: city_name
     }

    location_data
  end
end

