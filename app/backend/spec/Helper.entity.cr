class Helper
  def self.create_travel_plan()
    header = HTTP::Headers{"Content-Type" => "application/json"}
    travel_stops_1 = TravelData::CREATE_NEW_TRAVEL_MOCK_1.to_json
  
    post "/travel_plans", headers: header, body: travel_stops_1
  end
  
  def self.create_travel_plans_with_ids(id_arr)
    header = HTTP::Headers{"Content-Type" => "application/json"}
    travel_stops = { "travel_stops": id_arr }.to_json
  
    post "/travel_plans", headers: header, body: travel_stops
  end
  
  def self.create_travel_plans()
    header = HTTP::Headers{"Content-Type" => "application/json"}
    travel_stops_1 = TravelData::CREATE_NEW_TRAVEL_MOCK_1.to_json
    travel_stops_2 = TravelData::CREATE_NEW_TRAVEL_MOCK_2.to_json
  
    post "/travel_plans", headers: header, body: travel_stops_1
    post "/travel_plans", headers: header, body: travel_stops_2
  end

  def self.create_headers
    HTTP::Headers{"Content-Type" => "application/json"}
  end

  def self.check_response(expected_body, expected_status_code)
    response.body.should eq expected_body
    response.status_code.should eq expected_status_code
  end
end