class LocationsController < ApplicationController
  def show
    @location = Location.find(params[:id])
    @comments = @location.comments
  end
end
