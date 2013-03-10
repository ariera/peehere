module Api
  class UsersController < ApplicationController
    def create
      user = User.find_or_create(params)
      debugger
      respond_to do |format|
        format.xml  { render :xml  => user }
        format.json { render :json => user }
      end
    end
  end
end
