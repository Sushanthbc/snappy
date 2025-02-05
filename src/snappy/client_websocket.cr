require "http/web_socket"

module Snappy
  module ClientWebSocket
    def self.run
      ws = HTTP::WebSocket.new(URI.parse(Snappy.config.client_ws_url))

      ws.on_message do |message|
        p! message
        i = 0
        loop do
          Snappy.config.redis.publish("read", message)
          sleep 0.5.seconds
        end
      end

      ws.run
    end
  end
end
