class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_existence
    @given_key = params[:key][:value].strip
    if(!Key.exists?(:value => @given_key))
      redirect_to root_path, alert: "Invalid Key!"
    end
  end

end
