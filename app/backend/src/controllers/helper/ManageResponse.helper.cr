module TravelPlansRoute
  module TravelPlansController
    module Helper
      # Facilitates the creation of a Request response.
      #
      # ```
      # set_response_json("message", 200, env)
      # ```
      #
      # If the controller returns it, the message passed
      # will be set as the response body. Else it will
      # just set content_type and status_code.
      # 
      # This was thinked as a expansible method, so
      # with room to set more headers, cookies, etc.
      #
      # **note:** env is a `HTTP::Server::Context` object
      # served by `Kemal` on routes.
      def self.set_response_json(message : String, status_code : Int32, env : HTTP::Server::Context)
        env.response.content_type = "application/json"
        env.response.status_code = status_code
    
        {
          message: message,
          status_code: status_code
        }.to_json
      end
    end
  end
end