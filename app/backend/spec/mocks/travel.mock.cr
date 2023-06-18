# spec/mocks/travel.mock.cr

module TravelData
  CREATE_NEW_TRAVEL_MOCK_1 = {
    "travel_stops": [1, 2]
  }.to_json
  
  CREATE_NEW_TRAVEL_MOCK_2 = {
    "travel_stops": [10, 20]
  }.to_json
  
  CREATED_TRAVEL_MOCK_1 = {
    "id": 1,
    "travel_stops": [1, 2]
  }.to_json

  CREATED_TRAVEL_MOCK_2 = {
    "id": 2,
    "travel_stops": [10, 20]
  }.to_json
end