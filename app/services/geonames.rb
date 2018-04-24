require 'net/http'
require 'json'
require 'pry'
require 'normalize_country'

class Geonames

# keys
google_maps_api = "AIzaSyBHf-pI5bEXmml-_C4kOFZKSAuGG9eH1kI"
geocode_username = "carraragiovanni"

# Input
puts "Enter a city: "
print "> "
city = gets.chomp
puts "Enter a range in degrees: "
print "> "
range = gets.chomp.to_f

# Google Maps
geocode = URI("https://maps.googleapis.com/maps/api/geocode/json?address=" + city + "&key=" + google_maps_api)
geocode_net = Net::HTTP.get_response(geocode)
geocode_net_json = JSON.parse(geocode_net.body)
lng = geocode_net_json["results"][0]["geometry"]["location"]["lng"]
lat = geocode_net_json["results"][0]["geometry"]["location"]["lat"]
country = ""
geocode_net_json["results"][0]["address_components"].each do |long_name|
  long_name["types"].each do |long_name_types|
    if long_name_types == "country"
      country = long_name["long_name"]
    end
  end
end

country_code = NormalizeCountry(country, :to => :alpha2)

# Bounds Calc
north = (lat + range).to_s
south = (lat - range).to_s
east = (lng + range).to_s
west = (lng - range).to_s

# Geonames
geonames = URI("http://api.geonames.org/citiesJSON?"\
  + "north=" + north\
  + "&south=" + south\
  + "&east=" + east\
  + "&west=" + west\
  + "&lang=" + country_code\
  + "&maxRows=" + 5.to_s\
  + "&username=" + geocode_username)
geonames_net = Net::HTTP.get_response(geonames)
geonames_net_json = JSON.parse(geonames_net.body)
cities = geonames_net_json["geonames"]

# Sorting
sorted = cities.sort_by do |city|
  city["population"]
end
sorted = sorted.reverse
sorted_cities = []
sorted.each do |city|
  sorted_cities << {name: city["name"], population: city["population"]}
end

end
