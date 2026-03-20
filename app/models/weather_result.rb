class WeatherResult
  attr_reader :zipcode,
    :neighborhood,
    :lat,
    :lon,
    :city,
    :description,
    :temp,
    :feels_like,
    :sunrise,
    :sunset,
    :timezone,
    :error

  def initialize(data:, error: nil)
    @error = error
    return if error

    @zipcode = data[:zipcode]
    @neighborhood = data[:neighborhood]
    @lat = data[:lat]
    @lon = data[:lon]
    @description = data[:description]
    @temp = data[:temp]

    @feels_like = data[:feels_like]
    @sunrise = data[:sunrise]
    @sunset = data[:sunset]
    @timezone = data[:timezone]
  end

  def success?
    @error.nil?
  end
end
