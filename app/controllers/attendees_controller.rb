class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :edit, :update, :destroy]
  before_action :set_trip, only: [:create, :destroy]
  before_action :authorize
 
  # GET /attendees
  # GET /attendees.json
  def index
    @attendees = Attendee.all
    @attendees_ids = []
    @attendees.each do |a|
      @attendees_ids.push(a.user_id)
    end
  end

  # GET /attendees/new
  def new
    @attendee = Attendee.new
  end

  # POST /attendees
  # POST /attendees.json
  def create
    params.each do |key, value|
    end

    @trips = Trip.all
    @attendee = Attendee.new(attendee_params)
    @attendee.trip_id = params[:trip_id]
    @attendee.user_id = current_user.id
    @attendee.balance = 0
    @attendees = Attendee.where(trip_id: params[:trip_id])
    @trip_length_night = (@trip.end_date - @trip.start_date).to_i
    @price_per_night = @trip.price_per_night
    @total_cost = @price_per_night.to_i * @trip_length_night.to_i

    if @attendee.save
      @total_confirmed_accomodation_cost_per_person = @total_cost.to_i / @attendees.size
      @trip.update_attribute(:total_confirmed_cost, @total_confirmed_accomodation_cost_per_person)
      redirect_to @trip, notice: 'A new guest has joined your trip!'
    else
      render json: @attendee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attendees/1
  # PATCH/PUT /attendees/1.json
  def update
    respond_to do |format|
      if @attendee.save
        format.html { redirect_to @trip, notice: 'Attendee was successfully created.' }
        format.json { render :show, status: :created, location: trip_path }
      else
        format.html { redirect_to @trip, notice: 'Attendee not successfully created.' }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendees/1
  # DELETE /attendees/1.json
  def destroy
    @attendees = Attendee.where(trip_id: params[:trip_id])
    @trip_length_night = (@trip.end_date - @trip.start_date).to_i
    @price_per_night = @trip.price_per_night
    @total_cost = @price_per_night.to_i * @trip_length_night.to_i
    @attendee.destroy
    if @attendee.destroy
      @attendees = Attendee.where(trip_id: params[:trip_id])
      @trip_length_night = (@trip.end_date - @trip.start_date).to_i
      @price_per_night = @trip.price_per_night
      @total_cost = @price_per_night.to_i * @trip_length_night.to_i
      if @attendees.size > 0
      @total_confirmed_accomodation_cost_per_person = @total_cost.to_i / @attendees.size
      @trip.update_attribute(:total_confirmed_cost, @total_confirmed_accomodation_cost_per_person)
      else 
       @trip.update_attribute(:total_confirmed_cost, 0) 
      end
    end
    respond_to do |format|
      format.html { redirect_to @trip, notice: 'An attendee can no longer make the trip.' }
      format.json { head :no_content }
    end
  end

  private
    def set_trip
      @trip = Trip.find(params[:trip_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendee_params
      params.permit(:trip_id, :user_id, :balance)
    end
end