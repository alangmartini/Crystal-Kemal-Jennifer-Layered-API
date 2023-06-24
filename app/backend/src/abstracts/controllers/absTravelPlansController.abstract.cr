module TravelPlansRoute
  module TravelPlansController
    # Defined as abstract class for travel plans controllers
    abstract class AbstractTravelPlansController
      abstract def create_travel_plan(env : HTTP::Server::Context)
      abstract def get_all_travel_plans(env : HTTP::Server::Context)
    end
  end
end