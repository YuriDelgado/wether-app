class HomeController < ApplicationController
  def index
  end

  def search
    zipcode = params[:zipcode]&.strip
    return redirect_with_error(
      "Código postal requerido"
    ) if zipcode.blank?

    result = OpenWeatherService.new.weather_by_zip(zipcode)

    unless result&.success?
      flash[:error] = result&.error || "Unknown error"
      return redirect_to root_path
    end

    @weather = result
    flash[:weather] = @weather

    render :index
  end
end
