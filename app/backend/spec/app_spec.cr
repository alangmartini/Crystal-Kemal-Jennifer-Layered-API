require "./spec_helper"


describe "Travels::Kemal:App" do
  it "correctly creates a new Travel Plan" do
    travel_stops = TravelData::CREATE_NEW_TRAVEL_MOCK
    header = HTTP::Headers{"Content-Type" => "application/json"}

    get "/", headers: header, body: travel_stops

    response.body.should eq TravelData::CREATED_TRAVEL_MOCK
    response.status_code.should eq 201
  end
end
