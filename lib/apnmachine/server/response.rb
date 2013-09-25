module ApnMachine
  module Server
    class Response

      # TODO Implement feedback service using this skeleton
      def initialize(notification)
        @notification = notification
      end

      def to_s
        "TOKEN=#{@notification.token}"
      end
    end
  end
end