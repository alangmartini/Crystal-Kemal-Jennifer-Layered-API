# spec/mocks/travel.mock.cr

module TravelData
  CREATE_NEW_TRAVEL_MOCK_1 = {
    "travel_stops": [1, 2]
  }
  
  CREATE_NEW_TRAVEL_MOCK_2 = {
    "travel_stops": [10, 3]
  }
  
  POST_CREATED_TRAVEL_MOCK_1 = { "id": 1, "travel_stops": [1, 2] }

  POST_CREATED_TRAVEL_MOCK_2 = { "id": 2, "travel_stops": [10, 3] }

  GET_CREATED_TRAVEL_MOCK_1 = { "id": 2, "travel_stops": [1, 2] }

  GET_CREATED_TRAVEL_MOCK_2 = { "id": 3, "travel_stops": [10, 3] }

  PUT_UPDATED_TRAVEL_MOCK = { "id": 11, "travel_stops": [10, 3] }

  DELETE_CREATED_TRAVEL_MOCK = { "id": 12, "travel_stops": [1, 2]}

end