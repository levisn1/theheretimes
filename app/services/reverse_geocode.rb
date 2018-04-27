require 'net/http'
require 'json'
require 'pry'


class ReverseGeocode

  GOOGLE_MAPS_GEOCODE_API = "AIzaSyBHf-pI5bEXmml-_C4kOFZKSAuGG9eH1kI"

  def initialize(coordinates)
    @coordinates = coordinates
  end

  def call
    geocode = URI("https://maps.googleapis.com/maps/api/geocode/json?latlng=" + @coordinates[:lat].to_s + "," + @coordinates[:lng].to_s + "&key=" + GOOGLE_MAPS_GEOCODE_API)
    geocode_net = Net::HTTP.get_response(geocode)
    geocode_net_json = JSON.parse(geocode_net.body)
    latitude = @coordinates[:lat].to_f
    longitude = @coordinates[:lng].to_f

    country_code = ""
    geocode_net_json["results"][0]["address_components"].each do |short_name|
      short_name["types"].each do |short_name_types|
        if short_name_types == "country"
          country_code = short_name["short_name"]
        end
      end
    end

    # binding.pry

    city_name = ""
    # geocode_net_json["results"].each do |result|
    #   result
    # end

    geocode_net_json["results"][0]["address_components"].each do |short_name|
      short_name["types"].each do |short_name_types|
        if short_name_types == "locality"
          city_name = short_name["short_name"]
        end

        if short_name_types == "locality"
          city_name = short_name["long_name"]
        end

        break if not city_name.blank?
      end
    end

    location_data = {
      "lng" => longitude,
      "lat" => latitude,
      "north" => @coordinates[:north].to_s,
      "south" => @coordinates[:south].to_s,
      "east" => @coordinates[:east].to_s,
      "west" => @coordinates[:west].to_s,
      "countrycode" => country_code,
      "name" => city_name
     }

    location_data
  end
end

