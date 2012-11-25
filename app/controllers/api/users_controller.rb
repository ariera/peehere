module Api
  class UsersController < ApplicationController
    def create
      user = User.create(name:params[:name], email:params[:email])
      respond_to do |format|
        format.xml  { render :xml  => user }
        format.json { render :json => user }
      end
    end
  end
end
