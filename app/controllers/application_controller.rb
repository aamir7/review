
class ApplicationController < ActionController::Base
  
  before_action :authenticate_user!
  around_action :set_current_user
  
  protect_from_forgery    with: :exception
  rescue_from Exception,  with: :handle_exceptions
   
  def current_ability
    @current_ability ||= AbilityFactory.build_ability_for(current_user)
  end
  
  private
  def set_current_user
    User.current_user = current_user
    yield
  end 
      
  def handle_exceptions(exception)
    logger.error "Error Message: #{exception.message}"
    logger.error exception.backtrace.join("\n")
    
    case exception
    when ActionController::RoutingError
      not_found
    else
      respond_to do |format|
        format.html do
          flash[:error] = exception.message
          redirect_to user_root_path 
        end
        format.js do
          flash.now[:error] = exception.message
          render "/shared/errors.js.erb" 
        end
      end
    end
  end
  
  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
end
