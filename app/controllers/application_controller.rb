
class ApplicationController < ActionController::Base
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  around_action :set_current_user
  
  protect_from_forgery    with: :exception
  rescue_from Exception,  with: :handle_exceptions
   
  def current_ability
    @current_ability ||= AbilityFactory.build_ability_for(current_user)
  end
              
  # ------------ Exceptions -----------
  private
  def set_current_user
    User.current_user = current_user
    yield
#  ensure
#    User.current_user = nil
  end 
      
  def handle_exceptions(exception)
    logger.error "Error Message: #{exception.message}"
    logger.error exception.backtrace.join("\n")
#    exception.backtrace.each { |line| logger.error line }
    
    case exception
    when ActionController::RoutingError
      not_found
    else
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
  end
    
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
  end
  
  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
end
