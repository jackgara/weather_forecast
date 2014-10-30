require 'httparty'

class ForecastsController < ApplicationController
  #before_action :set_forecast, only: [:show, :edit, :update, :destroy]

  attr_accessor :date, :location,:hourly_data


  def index
    @forecast ||=Forecast.new(default_params)
    @response = wund_query
    populate
  end

  def create
    @forecast = Forecast.new(forecast_params)
    @response = wund_query     
    populate
      respond_to do |format|
          format.html { render :index}
      end
    return
  end

  private
    def default_params
      defparams = {:location => "autoip"}
    end

    # Never trust parameters from the scary internet, only allow the white list through. %{params[city]}
    def forecast_params
      params.require(:forecast).permit(:location,:date)
    end

    def wund_query
          w_api = Wunderground.new("884f81f70fbe5d77")
          response = w_api.forecast10day_and_conditions_and_hourly10day_for(@forecast.location)
          
          if(response["response"]["error"])
            flash[:notice] = "Weather Report not found. Type: #{response["response"]["error"]["type"]}"
            reset_to_default_forecast
            response = w_api.forecast_and_conditions_and_hourly_for(@forecast.location)
          else
            flash[:notice] = "Weather Report succesful"
          end
          return response      
    end

    def reset_to_default_forecast
        defparams = default_params
        @forecast.location =  defparams[:location]
    end

    def populate
        if(@response)
          @forecast.daytxt = @response['forecast']['txt_forecast']['forecastday']  
          @forecast.daysimple=@response['forecast']['simpleforecast']['forecastday']
          @forecast.hourly = @response['hourly_forecast']
          @forecast.current =@response['current_observation']
          @forecast.hourly_data = create_json_hourly_data

        end
    end

    def create_json_hourly_data
      data= []
      @forecast.hourly.each do |h|
        hour=[h['FCTTIME']['epoch'].to_i , h['temp']['metric'].to_i]
        data.push(hour)
      end
      return data
    end

end
