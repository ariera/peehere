module Admin
  class LocationsController < ApplicationController
    #http_basic_authenticate_with(:name => "wepeehere", :password => "dickface123") unless Rails.env.development?
    before_filter :ensure_current_user_is_admin

    def index
      @locations = Location.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @locations }
      end
    end

    def show
      @location = Location.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @location }
      end
    end

    def new
      @location = Location.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @location }
      end
    end

    def edit
      @location = Location.find(params[:id])
    end

    def create
      @location = Location.new(params[:location])

      respond_to do |format|
        if @location.save
          format.html { redirect_to @location, notice: 'Location was successfully created.' }
          format.json { render json: @location, status: :created, location: @location }
        else
          format.html { render action: "new" }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @location = Location.find(params[:id])

      respond_to do |format|
        if @location.update_attributes(params[:location])
          format.html { redirect_to @location, notice: 'Location was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @location.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @location = Location.find(params[:id])
      @location.destroy

      respond_to do |format|
        format.html { redirect_to locations_url }
        format.json { head :no_content }
      end
    end

    def rate
      if request.post?
        loc  = Location.find_or_create(params)
        user = current_user
        ratings = user.create_ratings(loc, params[:ratings])
        loc.update_statistics!
        redirect_to loc
      else
        @location = Location.find_by_id(params[:id]) || Location.new(indoor:params[:indoor])
        render :rate      
      end
    end
  end
end
