module Api
  class LocationsController < ApplicationController
    # => devolver una lista de localizaciones
    # filtradas por indoor
    # en función de una [lat,long] o una address
    #
    # cada loc
    #   lat, log, indoor, ¿overall?
    def index
      respond_to do |format|
        format.xml  { render :xml  => Location.all }
        format.json { render :json => Location.all }
      end
    end

    def show
      loc = Location.find(params[:id])
      respond_to do |format|
        format.xml  { render :xml  => loc }
        format.json { render :json => loc }
      end
    end

    def rate
      loc  = Location.find_or_create(params)
      user = User.find(params[:user_id])
      ratings = user.create_ratings(loc, params[:ratings])
      loc.update_average!

      respond_to do |format|
        format.xml  { render :xml  => ratings }
        format.json { render :json => ratings }
      end      
    end

    # por lat, long o por address 
    # devolver restaurantes / bares cercanos
    def find_around
      
    end

  end
end
