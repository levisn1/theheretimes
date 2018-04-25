require_relative 'webhoseio'

class Webhose
  WEBHOSE_KEY = "454c50ef-68d0-43b3-9fea-37c4a9178399"

  def initialize(list_of_sorted_cities)
    @list_of_sorted_cities = list_of_sorted_cities
  end

  def call
    @results = {}

    # default: timestamp of 20 days before the api call
    crawl_timestamp = ((Date.today - 30*24*60*60).to_time.to_i * 1000).to_s

    # default language of the articles: to be grabbed from the IP (?). Now set to Italian
    language = @list_of_sorted_cities[0][:language]

    @list_of_sorted_cities.each do |city_name|
      if city_name[:population] > 40000 # when the city has more than 40000 pp we look through the titles of the articles
        title = "title:"
        city_query = city_name[:name]
        time_span = 2
      else # when the city has more than 40000 pp we look through the titles of the articles
        title = ""
        city_query = city_name[:name]
        time_span = 7
      end
      published_timestamp = ((Date.today - time_span).to_time.to_i * 1000).to_s



      webhoseio = Webhoseio.new(WEBHOSE_KEY)
      query_params = {
        "q" => title + "#{city_query} language:#{language} site_type:news published:>#{published_timestamp}",
        "ts" => "#{crawl_timestamp}",
        "sort" => "performance_score",
        "size" => "20"
      }

      # raise
      output = webhoseio.query('filterWebContent', query_params)

      @results[city_name[:name]] = output
    end
    @results
  end
end

