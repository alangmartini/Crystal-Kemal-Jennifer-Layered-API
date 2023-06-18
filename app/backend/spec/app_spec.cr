require "./spec_helper"

def create_travel_plan()
  header = HTTP::Headers{"Content-Type" => "application/json"}
  travel_stops_1 = TravelData::CREATE_NEW_TRAVEL_MOCK_1

  post "/travel-plans", headers: header, body: travel_stops_1
end

def create_travel_plans()
  header = HTTP::Headers{"Content-Type" => "application/json"}
  travel_stops_1 = TravelData::CREATE_NEW_TRAVEL_MOCK_1
  travel_stops_2 = TravelData::CREATE_NEW_TRAVEL_MOCK_2

  post "/travel-plans", headers: header, body: travel_stops_1
  post "/travel-plans", headers: header, body: travel_stops_2
end

describe "Travels::Kemal:App" do
  it "correctly creates a new Travel Plan" do
    create_travel_plan()

    response.body.should eq TravelData::CREATED_TRAVEL_MOCK_1
    response.status_code.should eq 201
  end

  it "correctly retrieve all travel plans" do
    create_travel_plans()

    header = HTTP::Headers{"Content-Type" => "application/json"}

    get "/travel-plans", headers: header

    response.body.should eq [TravelData::CREATED_TRAVEL_MOCK_1, TravelData::CREATED_TRAVEL_MOCK_2].to_json
    response.status_code.should eq 200
  end

end
