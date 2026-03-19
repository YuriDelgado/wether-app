require "net/http"

class OpenWeatherService
  BASE_URL = "https://api.openweathermap.org"
  API_KEY = ENV.fetch("OPENWEATHER_API_KEY")

  def self.fetch_location(zipcode, country = "MX")
    uri = URI("#{BASE_URL}/geo/1.0/zip?zip=#{zipcode},#{country}&appid=#{API_KEY}")
    response = Net::HTTP.start(
      uri.host,
      uri.port,
      use_ssl: true
    ) do |http|
      request = Net::HTTP::Get.new(uri)

      http.request(request)
    end

    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.fetch_weather(lat, lon, lang = "es")
    uri = URI("#{BASE_URL}/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{API_KEY}&units=metric&lang=#{lang}")
    response = Net::HTTP.start(
      uri.host,
      uri.port,
      use_ssl: true
    ) do |http|
      request = Net::HTTP::Get.new(uri)

      http.request(request)
    end

    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body, symbolize_names: true)
  end
end
