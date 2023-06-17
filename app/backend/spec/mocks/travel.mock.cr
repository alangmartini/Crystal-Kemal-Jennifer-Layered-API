# spec/mocks/travel.mock.cr

module TravelData
  CREATE_NEW_TRAVEL_MOCK = {
    "travel_stops": [1, 2]
  }.to_json
  
  CREATED_TRAVEL_MOCK = {
    "id": 1,
    "travel_stops": [1, 2]
  }.to_json
end