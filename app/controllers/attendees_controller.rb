class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :edit, :update, :destroy]
  before_action :set_trip, only: [:create, :destroy]
 
  # GET /attendees
  # GET /attendees.json
  def index
    @attendees = Attendee.all
    @attendees_ids = []
    @attendees.each do |a|
      @attendees_ids.push(a.user_id)
    end
  end

  # GET /attendees/1
  # GET /attendees/1.json
  def show
  end

  # GET /attendees/new
  def new
    @attendee = Attendee.new
  end

  # GET /attendees/1/edit
  def edit
  end

  # POST /attendees
  # POST /attendees.json
  def create
    params.each do |key, value|
    end

    @attendee = Attendee.new(attendee_params)
    @attendee.trip_id = params[:trip_id]
    @attendee.user_id = current_user.id
    @attendee.balance = 0
    
    if @attendee.save
      redirect_to @trip, notice: 'Attendee was successfully created.'
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
    @attendee.destroy
    respond_to do |format|
      format.html { redirect_to @trip, notice: 'Attendee was successfully destroyed.' }
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
