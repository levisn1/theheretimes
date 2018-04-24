require_relative 'webhoseio'

class Webhose
  sorted_cities = [{:name=>"München", :population=>1260391},
                  {:name=>"Augsburg", :population=>259196},
                  {:name=>"Regensburg", :population=>5},
                  {:name=>"Ingolstadt", :population=>120658},
                  {:name=>"Innsbruck", :population=>112467}]


  webhose_key = "454c50ef-68d0-43b3-9fea-37c4a9178399"

  # default: timestamp of 20 days before the api call
  crawl_timestamp = (Time.now - 30*24*60*60).to_i

  # default language of the articles: to be grabbed from the IP (?). Now set to Italian
  language = "italian"

  # sorted_cities = what is returned by the Geonames API
  sorted_cities.each do |city|

    if city[:population] > 40000

      # when the city has more than 40000 pp we look through the titles of the articles
      title = "title:"
      city_query = city[:name]

      # default: when the city has more than 40000 pp we look through articles published in the last 2 days
      time_span = 2


    else city[:population] < 40000

      # when the city has more than 40000 pp we look through the titles of the articles
      title = ""
      city_query = city[:name]

      # default: when the city has more than 40000 pp we look through articles published in the last 2 days
      time_span = 7

    end

    published_timestamp = (Time.now - time_span*24*60*60).to_i

    # binding.pry
    webhoseio = Webhoseio.new(webhose_key)
    query_params = {
      "q" => title + "#{city_query} language:#{language} site_type:news published:>#{published_timestamp}",
      "ts" => "#{crawl_timestamp}",
      "sort" => "performance_score",
      "size" => "20"
    }

    output = webhoseio.query('filterWebContent', query_params)

    output[:location] = city_query

    puts output[:location]
    # puts output['posts'][0]['url']
    # puts output['posts'][0]['title']
    # puts output['posts'][0]['text']

  end
end
