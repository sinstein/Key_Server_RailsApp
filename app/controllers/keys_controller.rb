class KeysController < ApplicationController
before_action :check_existence, except: [:block, :create]
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

  def unblock
    @key = Key.find(Key.where(:value => @given_key).first.id)
    if(@key.block_time == 0)
      redirect_to root_path, alert: "Key #{@key.value} is not blocked."
    else
      @key.update_column(:block_time, 0)
      redirect_to root_path, notice: "Key #{@key.value} has been unblocked."
    end
  end

  def keep_alive
    @key = Key.where(:value => @given_key).first
    @key.update_column(:alive_time, Time.now.to_i)
    redirect_to root_path, notice: "Keep alive key: #{@key.value} "
  end

  def delete
    Key.where(:value => @given_key).first.destroy
    redirect_to root_path, notice: "Key deleted!"
  end

end
