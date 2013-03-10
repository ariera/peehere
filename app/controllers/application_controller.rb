class ApplicationController < ActionController::Base
  #protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def ensure_current_user_is_admin
    redirect_to new_user_session_path unless current_user && current_user.is_admin?
  end
end
