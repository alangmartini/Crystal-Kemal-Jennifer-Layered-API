require "spec-kemal"
require "spec"
require "../config/config.cr"
require "../src/app"
require "../src/models/TravelPlans.model"
require "../src/models/RelTravelPlansTravelStops.model"
require "./mocks/travel_plans/travel.mock"
require "./mocks/travel_plans/expanded_travel.mock"
require "./Helper.entity"

Process.run("crystal", ["sam.cr", "setup_test"])

Spec.before_each do
  Jennifer::Adapter.default_adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.default_adapter.rollback_transaction
end


