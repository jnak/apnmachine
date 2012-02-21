module ApnMachine
  module Server
    class Client
      attr_accessor :pem, :host, :port, :password, :key, :cert, :close_callback

      def initialize(pem, host = 'gateway.push.apple.com', port = 2195, pass = nil)
        @pem, @host, @port, @password = pem, host, port, pass
      end

      def connect!
        raise "The path to your pem file is not set." unless @pem
        raise "The path to your pem file does not exist!" unless File.exist?(@pem)
        @key, @cert = @pem, @pem
        @connection = EM.connect(host, port, ApnMachine::Server::ServerConnection, self)
      end
        
      def disconnect!
        @connection.close_connection
      end

      def write(notif_bin)
        Config.logger.debug "#{Time.now} [#{host}:#{port}] New notif"
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