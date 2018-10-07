class ApixuApi
  def self.key
    raise "APIXU_APIKEY env variable not defined" if ENV['APIXU_APIKEY'].nil?

    ENV['APIXU_APIKEY']
  end

  def self.weather_in(city)
    url = "http://api.apixu.com/v1/current.xml?key=#{key}&q="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    response.parsed_response["root"]
  end
end
