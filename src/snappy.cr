require "kemal"
require "db"
require "pg"
require "dotenv"

module Snappy
  VERSION = "0.1.0"

  Dotenv.load
  
  # Setup all the configuration of the app
  Snappy.config do |c|
    c.db_url = ENV["POSTGRES_URL"]
    c.client_ws_url = ENV["CLIENT_WS_URL"]
    c.setup
  end

  ClientWebSocket.run

  def self.config
    Configuration::INSTANCE
  end

  def self.config(&)
    yield Configuration::INSTANCE
  end
end

require "./snappy/configuration"
require "./snappy/client_websocket"
