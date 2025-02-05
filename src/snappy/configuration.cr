module Snappy
  class Configuration
    INSTANCE = self.new

    property db_url : String | URI
    property client_ws_url : String, redis_url : String
    property env
    @db : DB::Database | Nil

    def initialize
      @db_url = ""
      @env = ""
      @client_ws_url = ""
      @redis_url = ""
    end

    def db
      @db ||= setup_db
    end
    
    def redis
      @redis ||= Redis.new
    end

    def setup
      db
      redis
    end

    private def setup_db
      DB.open(db_url)
    end
  end
end
