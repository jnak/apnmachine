module ApnMachine
  module Server
    class Client

      # The client that connects to Apple servers from the EventMachine reactor

      attr_accessor :pem, :apn_host, :apn_port, :password, :key, :cert, :close_callback

      # Sets all the attributes
      def initialize(pem, password = nil, apn_host = 'gateway.push.apple.com', apn_port = 2195)
        @pem, @pasword, @apn_host, @apn_port = pem, password, apn_host, apn_port
      end

      # Connects the client to Apple servers
      def connect!
        raise "The path to your pem file is not set." unless @pem
        raise "The path to your pem file does not exist!" unless File.exist?(@pem)
        @key, @cert = @pem, @pem
        @connection = EM.connect(apn_host, apn_port, ApnMachine::Server::ServerConnection, self)
      end
      
      # Disconnects the client
      def disconnect!
        @connection.close_connection
      end

      # Sends the notification bytes to Apple servers
      #
      # @param notif_bin [ApnMachine::Notification.to_bytes] 
      def write(notif_bin)
        Config.logger.debug "#{Time.now} New notif"
        @connection.send_data(notif_bin)
      end

      # Checks status of connection
      def connected?
        @connection.connected?
      end
      
      # Hook called by EventMachine
      def on_error(&block)
        @error_callback = block
      end

      # Hook called by EventMachine
      def on_close(&block)
        @close_callback = block
      end
      
    end #client
  end #server
end #apnmachine