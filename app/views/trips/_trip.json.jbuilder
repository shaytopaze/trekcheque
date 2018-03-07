json.extract! trip, :id, :name, :accomodation_url, :price_per_night, :number_of_possible_attendees, :start_date, :end_date, :total_possible_cost, :total_confirmed_cost, :locked, :created_at, :updated_at
json.url trip_url(trip, format: :json)
