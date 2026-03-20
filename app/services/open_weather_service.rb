class OpenWeatherService
  def initialize(client = OpenWeatherClient.new)
    @client = client
  end


  def weather_by_zip(zipcode)
    return WeatherResult.error(
      "Formato inválido"
    ) unless zipcode.match?(/\A\d{5}\z/)

    location = @client.fetch_location(zipcode)

    return WeatherResult.new(
      error: "Código postal inválido"
    ) unless location

    weather = @client.fetch_weather(
      lat: location[:lat],
      lon: location[:lon]
    )

    return WeatherResult.new(
      error: "No se pudo obtener el clima"
    ) unless weather

    build_result(location, weather)
  end

  private

  def build_result(location, weather)
    WeatherResult.new(
      data: {
        zipcode: location[:zip],
        neighborhood: location[:name],
        lat: location[:lat],
        lon: location[:lon],
        description: weather.dig(:weather, 0, :description),
        temp: weather.dig(:main, :temp),
        feels_like: weather.dig(:main, :feels_like),
        sunrise: Time.at(weather.dig(:sys, :sunrise)).strftime("%H:%M"),
        sunset: Time.at(weather.dig(:sys, :sunset)).strftime("%H:%M"),
        timezone: weather[:timezone] / 3600
      }
    )
  end
end
