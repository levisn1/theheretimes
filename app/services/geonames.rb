require 'net/http'
require 'json'

class Geonames

  GEONAMES_USERNAME = "carraragiovanni"

  def initialize(location_data, countries_json_path, languages_json_path)
    @location_data = location_data
    @countries_json_path = countries_json_path
    @languages_json_path = languages_json_path
  end

  def call
    self.get_language
    @list_of_sorted_cities = self.find_cities_in_the_bounding_box
  end

  def get_language
    file_country = File.read(@countries_json_path)
    countries = JSON.parse(file_country)
    language_code = countries[@location_data[:country_code]]["languages"]

    file_language = File.read(@languages_json_path)
    languages = JSON.parse(file_language)
    language = languages[language_code[0]]["name"]
  end

  def find_cities_in_the_bounding_box
    range = 1
    north = (@location_data[:latitude] + range).to_s
    south = (@location_data[:latitude] - range).to_s
    east = (@location_data[:longitude] + range).to_s
    west = (@location_data[:longitude] - range).to_s

    geonames = URI("http://api.geonames.org/citiesJSON?"\
                  + "north=" + north\
                  + "&south=" + south\
                  + "&east=" + east\
                  + "&west=" + west\
                  + "&lang=" + @location_data[:country_code]\
                  + "&maxRows=" + 5.to_s\
                  + "&username=" + GEONAMES_USERNAME)
    geonames_net = Net::HTTP.get_response(geonames)
    geonames_net_json = JSON.parse(geonames_net.body)
    @list_of_cities = geonames_net_json["geonames"]

    sorted = @list_of_cities.sort_by do |city|
      city["population"]
    end
    sorted = sorted.reverse

    list_of_sorted_cities = []
    # binding.pry
    sorted.each do |city|
      list_of_sorted_cities << {name: city["name"], population: city["population"], language: get_language}
    end

    list_of_sorted_cities
  end
end
