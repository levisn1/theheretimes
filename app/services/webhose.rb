require_relative 'webhoseio'

class Webhose
  WEBHOSE_KEY = "97914e5c-beb5-437a-a71c-126de5e15238"

  def initialize(list_of_sorted_cities)
    @list_of_sorted_cities = list_of_sorted_cities
  end

  def call(since = nil)
    @results = {}

    # default: timestamp of 20 days before the api call
    crawl_timestamp = ((Date.today - 30*24*60*60).to_time.to_i * 1000).to_s

    language = @list_of_sorted_cities[0][:language]

    @list_of_sorted_cities.each do |city|
      if city[:population] > 40000 # when the city has more than 40000 pp we look through the titles of the articles
        title = "title:"
        city_query = city[:name]
        time_span = 2
      else # when the city has more than 40000 pp we look through the titles of the articles
        title = ""
        city_query = city[:name]
        time_span = 7
      end

      if since
        time_span = since.to_i
      end

      # time_span = 30 if time_span > 30

      published_timestamp = ((Date.today - time_span).to_time.to_i * 1000).to_s

      webhoseio = Webhoseio.new(WEBHOSE_KEY)
      query_params = {
        "q" => title + "#{city_query} language:#{language} site_type:news published:>#{published_timestamp}",
        "ts" => "#{crawl_timestamp}",
        "sort" => "performance_score",
        "size" => "30"
      }

      output = webhoseio.query('filterWebContent', query_params)

      output["posts"].each do |article|
        article["thread"]["city"] = city[:name]
        article["thread"]["latitude"] = city[:latitude]
        article["thread"]["longitude"] = city[:longitude]
        article["thread"]["population"] = city[:population]
      end
      @results[city[:name]] = output
    end
    @results
  end
end

