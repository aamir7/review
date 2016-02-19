
class ApplicationController < ActionController::Base
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protect_from_forgery with: :exception
  rescue_from Exception, with: :handle_exceptions
   
  def current_ability
    @current_ability ||= AbilityFactory.build_ability_for(current_user)
  end
    
  # ------------ Exceptions -----------
  private
  def handle_exceptions(exception)
    respond_to do |format|
      format.html do
        flash[:error] = exception.message
        redirect_to root_path 
      end
      format.js do
        flash.now[:error] = exception.message
        render "/shared/errors.js.erb" 
      end
    end
  end
    
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
