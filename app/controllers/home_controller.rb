class HomeController < ApplicationController
  def index
  end

  def search
    @zip_code = params[:zip_code]
    service = OpenWeatherService.new
    location = service.fetch_location(@zip_code)
    @lat = location[:lat]
    @lon = location[:lon]
    @neighbor = location[:name]

    weather = service.fetch_weather(location[:lat], location[:lon])
  end
end
