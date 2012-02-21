module ApnMachine
  module Server
    class Client
      attr_accessor :pem, :apn_host, :apn_port, :password, :key, :cert, :close_callback

      def initialize(pem, password = nil, apn_host = 'gateway.push.apple.com', apn_port = 2195)
        @pem, @pasword, @apn_host, @apn_port = pem, password, apn_host, apn_port
      end

      def connect!
        raise "The path to your pem file is not set." unless @pem
        raise "The path to your pem file does not exist!" unless File.exist?(@pem)
        @key, @cert = @pem, @pem
        @connection = EM.connect(apn_host, apn_port, ApnMachine::Server::ServerConnection, self)
      end
        
      def disconnect!
        @connection.close_connection
      end

      def write(notif_bin)
        Config.logger.debug "#{Time.now} New notif"
        @connection.send_data(notif_bin)
      end

      def connected?
        @connection.connected?
      end
    
      def on_error(&block)
        @error_callback = block
      end

      def on_close(&block)
        @close_callback = block
      end
      
    end #client
  end #server
end #apnmachine