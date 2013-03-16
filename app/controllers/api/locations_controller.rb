module Api
  class LocationsController < ApplicationController
    # params [:address, :latitude, :longitude, :show => [:indoor, :outdoor, :all], :distance]
    def index
      locations = Location.find_by_address_or_coords_and_filter(params)
      respond_to do |format|
        format.xml  { render :xml  => locations }
        format.json { render :json => locations }
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
      comment_text = params[:location].delete(:comment) if params[:location].present? && params[:location][:comment].present?
      loc  = Location.find_or_create(params)
      user = User.find(params[:user_id])
      comment = Comment.create(location_id:loc.id, user_id:user.id, body:comment_text) if comment_text.present? 
      ratings = user.create_ratings(loc, params[:ratings])
      loc.update_statistics!

      respond_to do |format|
        format.xml  { render :xml  => {url:loc.to_tweet} }
        format.json { render :json => ratings }
      end      
    end

    #def comment
    #  loc  = Location.find(params[:location_id])
    #  user = User.find(params[:user_id])
    #  comment = Comment.create(location_id:loc.id, user_id:user.id, body:params[:comment]) if params[:comment]
    #  respond_to do |format|
    #    format.xml  { render :xml  => comment }
    #    format.json { render :json => comment }
    #  end            
    #end

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
