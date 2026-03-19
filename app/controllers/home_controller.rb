class HomeController < ApplicationController
  def index
  end

  def search
    zipcode = params[:zipcode]

    location = OpenWeatherService.fetch_location(zipcode)

    if location.nil?
      flash[:error] = "Código postal inválido"
      return redirect_to root_path
    end

    @zipcode = zipcode
    @lat = location[:lat]
    @lon = location[:lon]
    @city = location[:name]

    weather = OpenWeatherService.fetch_weather(@lat, @lon)

    if weather.nil?
      flash[:error] = "No se pudo obtener el clima"
      return redirect_to root_path
    end

    @description = weather[:weather][0][:description]
    @temp = weather[:main][:temp]
    @feels_like = weather[:main][:feels_like]

    @sunrise = Time.at(weather[:sys][:sunrise])
    @sunset = Time.at(weather[:sys][:sunset])

    @timezone = weather[:timezone] / 3600

    render :index
  end
end
