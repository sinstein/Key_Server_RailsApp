class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_existence
    if(params[:key])
      if(params[:key].is_a? String)
        @given_key = params[:key].strip
      else
        @given_key = params[:key][:value].strip
      end
      if(!Key.exists?(:value => @given_key))
        redirect_to root_path, alert: "Invalid Key!"
      end
    else
      redirect_to root_path
    end
  end

end
