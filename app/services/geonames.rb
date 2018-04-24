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

    country_code = ""
    geocode_net_json["results"][0]["address_components"].each do |short_name|
      short_name["types"].each do |short_name_types|
        if short_name_types == "country"
          country_code = short_name["short_name"]
        end
      end
    end

    # Language
    file_country = File.read('countries.json')
    countries = JSON.parse(file_country)
    language_code = countries[country_code]["languages"]

    file_language = File.read('languages.json')
    languages = JSON.parse(file_language)
    language = languages[language_code[0]]["name"]

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

    # binding.pry

    # Sorting
    sorted = cities.sort_by do |city|
      city["population"]
    end
    sorted = sorted.reverse
    sorted_cities = []
    sorted.each do |city|
      sorted_cities << {name: city["name"], population: city["population"], language: language}
    end
    puts sorted_cities
  end
