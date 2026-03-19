require "net/http"
class OpenWeatherService
  BASE_URL = "https://api.openweathermap.org"
  API_KEY = "75ce025965bea81b8af131e0430c9014"

  def fetch_location(zip_code, country = "MX")
    uri = URI("#{BASE_URL}/geo/1.0/zip?zip=#{zip_code},#{country}&appid=#{API_KEY}")
    response = Net::HTTP.get(uri)

    nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response, symbolize_names: true)
  end

  def fetch_weather(lat, lon, lang = "es")
    uri = URI("#{BASE_URL}/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{API_KEY}&lang=#{lang}")
    response = Net::HTTP.get(uri)

    nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response, symbolize_names: true)
  end
end
