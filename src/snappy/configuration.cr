module Snappy
  class Configuration
    INSTANCE = self.new

    property db_url : String | URI
    property client_ws_url : String
    property env
    @db : DB::Database | Nil

    def initialize
      @db_url = "postgresql://snappy@localhost:5432/snappy?ssl_mode=false"
      @env = "development"
      @client_ws_url = "wss://fstream.binance.com/ws/bnbusdt@aggTrade"
    end

    def db
      @db ||= setup_db
    end

    def setup
      db
    end

    private def setup_db
      DB.open(db_url)
    end
  end
end
