module Api
  class LocationsController < ApplicationController
    # params [:address, :latitude, :longitude, :show => [:indoor, :outdoor, :all], :distance]
    def index
      locations = Location.find_by_address_or_coords_and_filter(params)
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
      loc.update_statistics!

      respond_to do |format|
        format.xml  { render :xml  => ratings }
        format.json { render :json => ratings }
      end      
    end

    # por lat, long o por address o por name
    # devolver restaurantes / bares cercanos
    def places
      locations = PlacesCache.find_places(params)
      respond_to do |format|
        format.xml  { render :xml  => locations.to_xml }
        format.json { render :json => locations }
      end
    end

  end
end
