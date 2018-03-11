module TheProtector
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if ENV["READ_ONLY"] == "true"
        if ["POST", "PUT", "PATCH", "DELETE"].include?(env["REQUEST_METHOD"])
          return [503, {'Content-Type' => 'text/plain'}, ['Service Unavailable']]
        end
      end

      @app.call(env)
    end
  end
end