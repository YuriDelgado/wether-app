require "net/http"
require "json"

class OpenWeatherClient
  BASE_URL = "https://api.openweathermap.org"
  API_KEY = ENV.fetch("OPENWEATHER_API_KEY")
  LANG_DEFAULT = "es"
  COUNTRY_DEFAULT = "MX"

  def fetch_location(zipcode)
    get(
      "/geo/1.0/zip",
      zip: "#{zipcode},#{COUNTRY_DEFAULT}",
      appid: API_KEY
    )
  end

  def fetch_weather(lat:, lon:)
    get(
      "/data/2.5/weather",
      lat: lat,
      lon: lon,
      appid: API_KEY,
      units: "metric",
      lang: LANG_DEFAULT
    )
  end

  private

  def get(path, params)
    uri = URI("#{BASE_URL}#{path}")

    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.start(
      uri.host,
      uri.port,
      use_ssl: true,
      open_timeout: 3,
      read_timeout: 3
    ) do |http|
      http.get(uri.request_uri)
    end

    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body, symbolize_names: true)

  rescue Net::OpenTimeout, Net::ReadTimeout => e
    Rails.logger.error("OpenWeather timeout: #{e.message}")

    nil
    rescue StandardError => e

      Rails.logger.error("OpenWeather unexpected error: #{e.message}")

      nil
  end
end
