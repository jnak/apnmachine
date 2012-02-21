module ApnMachine
  class Notification

    attr_accessor :device_token, :alert, :badge, :sound, :custom
    
    PAYLOAD_MAX_BYTES = 256
    class PayloadTooLarge < StandardError;end
    class NoDeviceToken < StandardError;end
    
    def encode_payload
      p = {:aps => Hash.new}
      [:badge, :alert, :sound].each do |k|
        p[:aps][k] = send(k) if send(k)
      end
      p.merge!(custom) if send(:custom)
      
      j = ActiveSupport::JSON.encode(p)
      raise PayloadTooLarge.new("The payload is larger than allowed: #{j.length}") if j.size > PAYLOAD_MAX_BYTES
      
      p[:device_token] = device_token
      raise NoDeviceToken.new("No device token") unless device_token
      
      ActiveSupport::JSON.encode(p)
    end
      
    def push
      raise 'No Redis client' if Config.redis.nil?
      socket = Config.redis.rpush "apnmachine.queue", encode_payload
    end
    
    def self.to_bytes(encoded_payload)
      notif_hash = ActiveSupport::JSON.decode(encoded_payload)
      
      device_token = notif_hash.delete('device_token')
      bin_token = [device_token].pack('H*')
      raise NoDeviceToken.new("No device token") unless device_token
      
      j = ActiveSupport::JSON.encode(notif_hash)
      raise PayloadTooLarge.new("The payload is larger than allowed: #{j.length}") if j.size > PAYLOAD_MAX_BYTES
      
      Config.logger.debug "TOKEN:#{device_token} | ALERT:#{notif_hash.inspect}"
      
      [0, 0, bin_token.size, bin_token, 0, j.size, j].pack("ccca*cca*")
    end
    
  end
  
end
