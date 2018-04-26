require 'net/http'
require 'json'

class Geocode

  GOOGLE_MAPS_GEOCODE_API = "AIzaSyBHf-pI5bEXmml-_C4kOFZKSAuGG9eH1kI"

  def initialize(city_name)
    @city_name = city_name
  end

  def call
    geocode = URI("https://maps.googleapis.com/maps/api/geocode/json?address=" + @city_name + "&key=" + GOOGLE_MAPS_GEOCODE_API)
    geocode_net = Net::HTTP.get_response(geocode)
    geocode_net_json = JSON.parse(geocode_net.body)
    longitude = geocode_net_json["results"][0]["geometry"]["location"]["lng"]
    latitude = geocode_net_json["results"][0]["geometry"]["location"]["lat"]

    country_code = ""

    geocode_net_json["results"][0]["address_components"].each do |short_name|
      short_name["types"].each do |short_name_types|
        if short_name_types == "country"
          country_code = short_name["short_name"]
        end
      end
    end

    location_data = {
      "lng" => longitude,
      "lat" => latitude,
      "countrycode" => country_code,
      "name" => @city_name
     }

    location_data
  end
end

