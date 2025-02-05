require "http/web_socket"

module Snappy
  module LoadTesting
    def self.run(spawns)
      2500.times do |i|
        spawn do
          ws = HTTP::WebSocket.new(URI.parse("ws://localhost:3002/"))
          ws.on_message do |message|
            p! message
          end
          ws.run
        end
        sleep 10.milliseconds
      end
      
      
      loop do
        sleep 1.seconds
      end
    end
  end
end
