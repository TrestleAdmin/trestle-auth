module Trestle
  module Auth
    module Backends
      class Base
        attr_reader :controller, :request, :session, :cookies

        def initialize(controller:, request:, session:, cookies:)
          @controller, @request, @session, @cookies = controller, request, session, cookies
        end

        # Default params scope to use for the login form.
        def scope
          :user
        end

        # Stores the previous return location in the session to return to after logging in.
        def store_location(url)
          session[:trestle_return_to] = url
        end

        # Returns (and deletes) the previously stored return location from the session.
        def previous_location
          session.delete(:trestle_return_to)
        end
      end
    end
  end
end
