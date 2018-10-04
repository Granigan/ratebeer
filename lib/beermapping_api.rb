class BeermappingApi
  def self.places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{self.key}/"
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.key
    "c56824873aaf76d8f4dfb4cd2c729349"
  end
end