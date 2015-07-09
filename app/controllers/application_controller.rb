class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_existence
    if(params[:key])
      @given_key = params[:key][:value].strip
      if(!Key.exists?(:value => @given_key))
        redirect_to root_path, alert: "Invalid Key!"
      end
    else
      redirect_to root_path
    end
  end

end
