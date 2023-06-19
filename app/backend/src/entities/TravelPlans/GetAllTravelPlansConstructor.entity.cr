class GetTravelPlansResponseConstructor
  def self.get_all_raw_travel_plans_from_db() : Array(RawTravelPlan)
    # In Jennifer, .all only refers to a query,
    # needing thus .to_json to execute it.
    result = TravelPlans.all.to_json

    raw_travel_plans : Array(RawTravelPlan) = JSON
      .parse(result).as_a
      .map { |row| RawTravelPlan.from_json(row.to_json) }

    raw_travel_plans
  end

  def self.get_travel_stops_from_db(raw_travel_plan : RawTravelPlan)
    travel_stops_id =  RelTravelPlansTravelStops
        .all
        .where { _travel_plan_id == raw_travel_plan.id }
        .to_json(only: %w[travel_stop_id])

      travel_stops_ids = JSON
        .parse(travel_stops_id)
        .as_a.map { |row| row["travel_stop_id"].as_i.to_i64 }

      puts typeof(travel_stops_ids[0])
      travel_stops_ids
  end

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
end