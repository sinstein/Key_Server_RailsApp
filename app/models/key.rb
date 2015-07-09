require 'securerandom'
require 'rufus-scheduler'

class Key < ActiveRecord::Base
  before_save :generate_key
  @ttl = 300;
  @ttb = 50;

  def generate_key
    key = SecureRandom.urlsafe_base64
    self.value = key;
    self.alive_time =  Time.now.to_i;
    self.block_time = 0;
  end

  scheduled_cleanup = Rufus::Scheduler.new
  scheduled_cleanup.every '10s' do
    keys = Key.all
    if(!keys.empty?)
      keys.each do |key|
        curr_time = Time.now.to_i
        if(curr_time - key.alive_time > @ttl)
          key.destroy
        elsif(key.block_time !=0 && curr_time - key.block_time > @ttb)
          key.update_column(:block_time, 0)
        end
      end
    end
  end
end
