require 'net/http'
require 'json'
require 'pry'


# params = {"lat"=>"45.451208056466186", "lng"=>"12.37502852304442", "west"=>"10.89187422616942", "east"=>"13.85818281991942", "north"=>"46.22045296832641", "south"=>"44.67132650333898"}
# location_data = ReverseGeocode.new(params).call
# list_of_sorted_cities = Geonames.new(location_data, "app/services/countries.json", "app/services/languages.json").call

class Geonames

  GEONAMES_USERNAME = "carraragiovanni"

  def initialize(location_data, countries_json_path, languages_json_path)
    @location_data = location_data
    @countries_json_path = countries_json_path
    @languages_json_path = languages_json_path
  end

  def call
    @list_of_sorted_cities = self.find_cities_in_the_bounding_box
  end

  def get_language
    file_country = File.read(@countries_json_path)
    countries = JSON.parse(file_country)
    language_code = countries[@location_data["countrycode"]]["languages"]

    file_language = File.read(@languages_json_path)
    languages = JSON.parse(file_language)
    language = languages[language_code[0]]["name"]
  end

  def find_cities_in_the_bounding_box
    @list_of_cities = get_cities(1, 3)

    if @list_of_cities.any? { |city| city["name"].strip.downcase == @location_data["name"].strip.downcase }
      "Ok"
    else
      @list_of_cities << get_cities(0.001, 1)[0]
    end

    @list_of_cities.uniq!
    @list_of_cities.reject! {|i| !i}

    list_of_sorted_cities = []

    language = get_language

    @list_of_cities.each do |city|
      list_of_sorted_cities << {
        latitude: city["lat"],
        longitude: city["lng"],
        name: city["name"],
        population: city["population"],
        language: language
      }
    end
    list_of_sorted_cities
  end

  def get_cities(radius, cities_count)

    if @location_data["west"]
      north = @location_data["north"].to_s
      south = @location_data["south"].to_s
      east = @location_data["east"].to_s
      west = @location_data["west"].to_s
    else
      range = radius
      north = (@location_data["lat"] + range).to_s
      south = (@location_data["lat"] - range).to_s
      east = (@location_data["lng"] + range).to_s
      west = (@location_data["lng"] - range).to_s
    end


    geonames = URI("http://api.geonames.org/citiesJSON?"\
      + "north=" + north\
      + "&south=" + south\
      + "&east=" + east\
      + "&west=" + west\
      + "&lang=" + @location_data["countrycode"]\
      + "&maxRows=" + cities_count.to_s\
      + "&username=" + GEONAMES_USERNAME)

    geonames_net = Net::HTTP.get_response(geonames)
    geonames_net_json = JSON.parse(geonames_net.body)
    geonames_net_json["geonames"]
  end
end
