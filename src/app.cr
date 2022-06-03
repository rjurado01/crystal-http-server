require "db"
require "pg"
require "http/server"

# TODO: Write documentation for `App`
module App
  VERSION = "0.1.0"

  struct User
    property name, email

    def initialize(@name : String, @email : String)
    end
  end

  class Repository
    property db : DB::Database

    def initialize
      user = "rjurado"
      host = "localhost"
      port = 5432
      db = "meka_erp_development"

      @db = DB.open("postgres://#{user}@#{host}:#{port}/#{db}?retry_attempts=10")
    end

    def get_users
      result = [] of User

      @db.query "select name, email from users" do |rs|
        rs.each do
          result.push User.new(
            rs.read(String),
            rs.read(String)
          )
        end
      end

      result
    end
  end

  # TODO: Put your code here
  class Server
    def run
      repository = Repository.new

      server = HTTP::Server.new do |context|
        context.response.content_type = "text/plain"

        case context.request.resource
        when "/users"
          context.response.print repository.get_users
        else
          context.response.print "Hello world! The time is #{Time.local}"
        end
      end

      address = server.bind_tcp 8000
      puts "Listening on http://#{address}"
      server.listen
    end
  end
end

app = App::Server.new
app.run
