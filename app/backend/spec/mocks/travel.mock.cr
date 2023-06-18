# spec/mocks/travel.mock.cr

module TravelData
  CREATE_NEW_TRAVEL_MOCK_1 = {
    "travel_stops": [1, 2]
  }
  
  CREATE_NEW_TRAVEL_MOCK_2 = {
    "travel_stops": [10, 20]
  }
  
  POST_CREATED_TRAVEL_MOCK_1 = { "id": 1, "travel_stops": [1, 2] }

  POST_CREATED_TRAVEL_MOCK_2 = { "id": 2, "travel_stops": [10, 20] }

  GET_CREATED_TRAVEL_MOCK_1 = { "id": 2, "travel_stops": [1, 2] }

  GET_CREATED_TRAVEL_MOCK_2 = { "id": 3, "travel_stops": [10, 20] }
end