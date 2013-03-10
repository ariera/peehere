module Api
  class UsersController < ApplicationController
    def create
      user = User.create(name:params[:name], email:params[:email], password: Devise.friendly_token[0,20])
      respond_to do |format|
        format.xml  { render :xml  => user }
        format.json { render :json => user }
      end
    end
  end
end
