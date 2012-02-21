module ApnMachine
  module Server
    class ServerConnection < EM::Connection
      attr_reader :client

      def initialize(*args)
        super
        @client = args.last
        @disconnected = false
      end

      def connected?
        !@disconnected
      end

      def post_init
        start_tls(
          :private_key_file => client.key,
          :cert_chain_file  => client.cert,
          :verify_peer      => false
        )
      end

      def connection_completed
        Config.logger.info "Connection to Apple Servers completed" 
      end

      def receive_data(data)
        data_array = data.unpack("ccN")
        Config.logger.info "Error"
        error_response = ErrorResponse.new(*data_array)
        Config.logger.warn(error_response.to_s)
        if client.error_callback
          client.error_callback.call(error_response)
        end
      end

      def unbind
        @disconnected = true
        Config.logger.info "Connection closed"
        client.close_callback.call if client.close_callback
      end
      
    end
  end
end