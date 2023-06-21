require "./spec_helper"
  describe "Travels::Kemal:App" do  
    # TODO: make this work (to actually clean the tables in  db)
    # for some reason, it doesnt resets the id, even thought is a rollback
    # and not a delete.
    # before_each do
    #   puts "before each"
    #   Jennifer::Adapter.default_adapter.begin_transaction
    # end

    # after_each do
    #   puts "after each"
    #   Jennifer::Adapter.default_adapter.rollback_transaction
    # end

    it "POST /travel_plans: creates a new Travel Plan" do
      Helper.create_travel_plan()
      Helper.check_response(TravelData::POST_CREATED_TRAVEL_MOCK_1.to_json, 201)
    end
  
    it "GET /travel_plans: retrieve all travel plans, no query" do
      Helper.create_travel_plans()
      get "/travel_plans", headers: Helper.create_headers
      Helper.check_response([
        TravelData::GET_CREATED_TRAVEL_MOCK_1,
        TravelData::GET_CREATED_TRAVEL_MOCK_2
      ].to_json, 200)
    end
  
    it "GET /travel_plans: retrieve all travel plans, optimised" do
      Helper.create_travel_plans_with_ids([2, 7, 9, 11, 19])
      get "/travel_plans?optimize=true", headers: Helper.create_headers
      expected_response = [
        {
          "id": 4,
          "travel_stops": [19, 9, 2, 11, 7]
        }
      ].to_json
      Helper.check_response(expected_response, 200)
    end
  
    it "GET /travel_plans: retrieve all travel plans, expanded" do
      Helper.create_travel_plans_with_ids([2, 3, 19, 20])
      get "/travel_plans?expand=true", headers: Helper.create_headers
      expected_response = [
        {
          "id": 5,
          "travel_stops": [
            ExpandedLocationsMocks::DIMENSION_2,
            ExpandedLocationsMocks::DIMENSION_3,
            ExpandedLocationsMocks::DIMENSION_19,
            ExpandedLocationsMocks::DIMENSION_20,
          ]
        }
      ].to_json
      Helper.check_response(expected_response, 200)
    end
  
    it "GET /travel_plans: retrieve all travel plans, expanded and optimised" do
      Helper.create_travel_plans_with_ids([2, 7, 9, 11, 19])
      get "/travel_plans?expand=true&optimize=true", headers: Helper.create_headers
      expected_response = [
        {
          "id": 6,
          "travel_stops": [
            ExpandedLocationsMocks::DIMENSION_19,
            ExpandedLocationsMocks::DIMENSION_9,
            ExpandedLocationsMocks::DIMENSION_2,
            ExpandedLocationsMocks::DIMENSION_11,
            ExpandedLocationsMocks::DIMENSION_7,
          ]
        }
      ].to_json
      Helper.check_response(expected_response, 200)
    end

    it "GET /travel_plans/:id: retrieve a travel plan by id, no query" do
      Helper.create_travel_plans_with_ids([2, 7, 9, 11, 19])
      get "/travel_plans/7", headers: Helper.create_headers
      expected_response = 
        {
          "id": 7,
          "travel_stops": [2, 7, 9, 11, 19]
        }.to_json
      Helper.check_response(expected_response, 200)
    end

    it "GET /travel_plans/:id: retrieve a travel plan by id, optimised" do
      Helper.create_travel_plans_with_ids([2, 7, 9, 11, 19])
      get "/travel_plans/8?optimize=true", headers: Helper.create_headers
      expected_response = 
        {
          "id": 8,
          "travel_stops": [19, 9, 2, 11, 7]
        }.to_json
      Helper.check_response(expected_response, 200)
    end
  
    it "GET /travel_plans/:id: retrieve a travel plan by id, expanded" do
      Helper.create_travel_plans_with_ids([2, 3, 19, 20])
      get "/travel_plans/9?expand=true", headers: Helper.create_headers
      expected_response = 
        {
          "id": 9,
          "travel_stops": [
            ExpandedLocationsMocks::DIMENSION_2,
            ExpandedLocationsMocks::DIMENSION_3,
            ExpandedLocationsMocks::DIMENSION_19,
            ExpandedLocationsMocks::DIMENSION_20,
          ]
        }.to_json
      Helper.check_response(expected_response, 200)
    end
  
    it "GET /travel_plans/:id: retrieve a travel plan by id, expanded and optimised" do
      Helper.create_travel_plans_with_ids([2, 7, 9, 11, 19])
      get "/travel_plans/10?expand=true&optimize=true", headers: Helper.create_headers
      expected_response = 
        {
          "id": 10,
          "travel_stops": [
            ExpandedLocationsMocks::DIMENSION_19,
            ExpandedLocationsMocks::DIMENSION_9,
            ExpandedLocationsMocks::DIMENSION_2,
            ExpandedLocationsMocks::DIMENSION_11,
            ExpandedLocationsMocks::DIMENSION_7,
          ]
        }.to_json
      Helper.check_response(expected_response, 200)
    end

    it "PUT /travel_plans/:id: update a Travel Plan" do
      Helper.create_travel_plan() # creates with CREATE_NEW_TRAVEL_MOCK_1 body

      body = TravelData::CREATE_NEW_TRAVEL_MOCK_2.to_json
      put "/travel_plans/11", headers: Helper.create_headers, body: body

      Helper.check_response(TravelData::PUT_UPDATED_TRAVEL_MOCK.to_json, 200)

      get "/travel_plans/11", headers: Helper.create_headers

      Helper.check_response(TravelData::PUT_UPDATED_TRAVEL_MOCK.to_json, 200)
    end

    
  end
