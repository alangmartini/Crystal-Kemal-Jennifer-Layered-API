
# Get `TravelPlans` from DB and construct them to `ConstructedTravelPlan` objects
class GetTravelPlansResponseConstructor
  # Get all `TravelPlans` from DB and construct them to `RawTravelPlan` objects
  def self.get_all_raw_travel_plans_from_db() : Array(RawTravelPlan)
    # In Jennifer, .all only refers to a query,
    # needing thus .to_json to execute it.
    result = TravelPlans.all.to_json
    raw_travel_plans : Array(RawTravelPlan) = JSON
      .parse(result).as_a
      .map { |row| RawTravelPlan.from_json(row.to_json) }

    raw_travel_plans
  end

  # Get all `TravelStops` related to specific `TravelPlans` from DB
  def self.get_travel_stops_from_db(raw_travel_plan : RawTravelPlan)
    travel_stops_id =  RelTravelPlansTravelStops
        .all
        .where { _travel_plan_id == raw_travel_plan.id }
        .to_json(only: %w[travel_stop_id])

      travel_stops_ids : Array(Int64) = JSON
        .parse(travel_stops_id)
        .as_a.map { |row| row["travel_stop_id"].as_i.to_i64 }

      travel_stops_ids
  end

  # Join `RawTravelPlan` as its TravelStops and construct them to `ConstructedTravelPlan` objects
  def self.get_all_constructed_travel_plans() : Array(ConstructedTravelPlan)
    raw_travel_plans = self.get_all_raw_travel_plans_from_db()

    raw_travel_plans
      .map do |raw_travel_plan|
        travel_stops_ids = self.get_travel_stops_from_db(raw_travel_plan)

        ConstructedTravelPlan.new(
          id: raw_travel_plan.id,
          travel_stops: travel_stops_ids
        )
      end
  end

  def self.get_all_unique_travel_stops_ids(
    construct_travel_plans : Array(ConstructedTravelPlan)
  ) : Array(Int64)

    travel_stops = [] of Int64
    construct_travel_plans
      .each { |a| a.travel_stops.each { |b| travel_stops << b } }

    travel_stops = travel_stops.uniq

    travel_stops
  end 
end