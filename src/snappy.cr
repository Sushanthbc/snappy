require "db"
require "pg"
require "dotenv"
require "option_parser"
require "kemal"
require "redis"

module Snappy
  VERSION = "0.1.0"

  Dotenv.load

  # Setup all the configuration of the app
  Snappy.config.db_url = "basic formatter"
  Snappy.config do |c|
    c.db_url = ENV["POSTGRES_URL"]
    c.client_ws_url = ENV["CLIENT_WS_URL"]
    c.redis_url = ENV["REDIS_URL"]
    c.setup
  end

  enable_websocket_flag = false

  OptionParser.parse do |parser|
    parser.banner = "Usage: salute [arguments]"
    parser.on("--client-websocket", "run the client web socket") do
      puts "executing client socket: #{ARGV}"
      ClientWebSocket.run
    end
    parser.on("--websocket-server", "run the web socket server") do
      enable_websocket_flag = true
      WebsocketServer.call
    end
    parser.on("--load-testing", "run the web socket server") do
      LoadTesting.run(1000)
    end
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end
    parser.invalid_option do |flag|
      STDERR.puts "ERROR: #{flag} is not a valid option."
      STDERR.puts parser
      exit(1)
    end
  end

  def self.config
    Configuration::INSTANCE
  end

  def self.config(&)
    yield Configuration::INSTANCE
  end

  spawn do
    Snappy.config.redis.subscribe("bnb") do |on|
      on.message do |channel, message|
        WebsocketServer::Connection.active.each do |s|
          if !s.closed?
            s.send(message)
          end
        end
      end
    end
  end

  if enable_websocket_flag
    Kemal.config.env = "production"
    Kemal.run(port: 3002)
  end
end

require "./snappy/configuration"
require "./snappy/client_websocket"
require "./snappy/websocket_server"
require "./snappy/load_testing"
