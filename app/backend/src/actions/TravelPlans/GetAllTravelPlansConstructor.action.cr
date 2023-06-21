
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

  # Get a single `TravelPlans` from DB and construct it to `RawTravelPlan` object
  # Returns an Array so its possible to use the same function as `get_all_raw_travel_plans_from_db`
  # for dealing with it later.
  def self.get_raw_travel_plan_from_db_by_id(id : String | Int32) : Array(RawTravelPlan)
    result = TravelPlans.where { _id == id }.to_json
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

  def self.construct_travel_plans(raw_travel_plans : Array(RawTravelPlan)) : Array(ConstructedTravelPlan)
    raw_travel_plans
      .map do |raw_travel_plan|
        travel_stops_ids = self.get_travel_stops_from_db(raw_travel_plan)

        ConstructedTravelPlan.new(
          id: raw_travel_plan.id,
          travel_stops: travel_stops_ids
        )
      end
  end

  # Join `RawTravelPlan` as its TravelStops and construct them to `ConstructedTravelPlan` objects
  def self.get_all_constructed_travel_plans() : Array(ConstructedTravelPlan)
    raw_travel_plans = self.get_all_raw_travel_plans_from_db()

    self.construct_travel_plans(raw_travel_plans)
  end

  # Join `RawTravelPlan` as its TravelStops and construct them to `ConstructedTravelPlan` objects
  # 
  def self.get_by_id_constructed_travel_plans(id : String | Int32) : Array(ConstructedTravelPlan)
    raw_travel_plans : Array(RawTravelPlan) = self.get_raw_travel_plan_from_db_by_id(id)

    self.construct_travel_plans(raw_travel_plans)
  end

  # Helper function. Get all unique `TravelStops` ids from `ConstructedTravelPlan` objects
  # Its used to avoid duplicates when getting locations from API
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