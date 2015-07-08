class KeysController < ApplicationController
def index
  redirect_to root_path
end

def new
  @key = Key.new
end

def create
  @key = Key.new
  if @key.save!
    redirect_to root_path, notice: "New key has been generated."
  else
    render "root", alert: "Error generating key. Try again."
  end
end

def block
  @available_keys = Key.where(:block_time => 0)
  if(!@available_keys.empty?)
    @key = Key.find(@available_keys[0].id)
    @key.update_column(:block_time, Time.now.to_i)
    redirect_to root_path, notice: "Key #{@key.value} has been blocked"
  else
    redirect_to root_path, alert: "No key available!"
  end
end

def process_request
  @given_key = params[:key][:value]
  @chosen_op = params[:request]
  if(@chosen_op.nil?)
    redirect_to root_path, alert: "Please choose request type!"
  else
    case @chosen_op
    when "unblock"
       redirect_to unblock_keys_path({value: @given_key}) and return
    when "delete"
       redirect_to delete_keys_path({value: @given_key}) and return
    when "keep_alive"
       redirect_to keep_alive_keys_path({value: @given_key}) and return
    end
  end
end

def unblock
  #debugger
  @given_key = params[:value]
  @given_key.strip!
  if(Key.exists?(:value => @given_key))
    @key = Key.find(Key.where(:value => @given_key).first.id)
    if(@key.block_time == 0)
      redirect_to root_path, alert: "Key #{@key.value} is not blocked."
    else
      @key.update_column(:block_time, 0)
      redirect_to root_path, notice: "Key #{@key.value} has been unblocked."
    end
  else
    redirect_to root_path, alert: "Invalid Key"
  end
end

def keep_alive
  #debugger
  if(Key.exists?(:value => params[:value]))
    @key = Key.where(:value => params[:value]).first
    @key.update_column(:alive_time, Time.now.to_i)
    redirect_to root_path, notice: "Keep alive key: #{@key.value} "
  else
    redirect_to root_path, alert: "Invlid Key"
  end
end

def delete
  #debugger
  if(Key.exists?(:value => params[:value]))
    #debugger
    Key.where(:value => params[:value]).first.destroy
    redirect_to root_path, notice: "Key deleted!"
  else
    redirect_to root_path, alert: "Invalid Key"
  end
end

def update
end

end
