module Snappy
  module WebsocketServer
    class Connection
      @@sockets = [] of HTTP::WebSocket
      
      def self.<<(socket)
        @@sockets << socket
      end

      def self.active
        @@sockets
      end
    end
    
    def self.call
      ws "/" do |socket|
        Connection << socket
        count = Connection.active
        pure_active = Connection.active.map { |c| c if !c.closed? }.compact
        p! pure_active.size


        socket.on_message do |message|
          p! message
        end

        socket.on_close do
          p! "bye! bye!"
        end
      end
    end
  end
end
