require "http/web_socket"

module Snappy
  module ClientWebSocket
    def self.run
      ws = HTTP::WebSocket.new(URI.parse(Snappy.config.client_ws_url))
      p! ws
      
      ws.on_message do |message|
        p! message
      end

      ws.run
    end
  end
end