require 'test_helper'

class TripsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trip = trips(:one)
  end

  test "should get index" do
    get trips_url
    assert_response :success
  end

  test "should get new" do
    get new_trip_url
    assert_response :success
  end

  test "should create trip" do
    assert_difference('Trip.count') do
      post trips_url, params: { trip: { accomodation_url: @trip.accomodation_url, end_date: @trip.end_date, locked: @trip.locked, name: @trip.name, number_of_possible_attendees: @trip.number_of_possible_attendees, price_per_night: @trip.price_per_night, start_date: @trip.start_date, total_confirmed_cost: @trip.total_confirmed_cost, total_possible_cost: @trip.total_possible_cost } }
    end

    assert_redirected_to trip_url(Trip.last)
  end

  test "should show trip" do
    get trip_url(@trip)
    assert_response :success
  end

  test "should get edit" do
    get edit_trip_url(@trip)
    assert_response :success
  end

  test "should update trip" do
    patch trip_url(@trip), params: { trip: { accomodation_url: @trip.accomodation_url, end_date: @trip.end_date, locked: @trip.locked, name: @trip.name, number_of_possible_attendees: @trip.number_of_possible_attendees, price_per_night: @trip.price_per_night, start_date: @trip.start_date, total_confirmed_cost: @trip.total_confirmed_cost, total_possible_cost: @trip.total_possible_cost } }
    assert_redirected_to trip_url(@trip)
  end

  test "should destroy trip" do
    assert_difference('Trip.count', -1) do
      delete trip_url(@trip)
    end

    assert_redirected_to trips_url
  end
end
