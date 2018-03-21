class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :authorize
 
  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.all
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @trip_types = [["Weekend Getaway", 1], ["Boys Trip", 2], ["Bachelorette", 3], ["Road Trip", 4], ["Adventure", 5], ["Other", 6]]
    @trips = Trip.all
    @message = Message.new
    @messages = Message.where(trip_id: params[:trip_id])
    @expense = Expense.new
    @new_trip = Trip.new
    @attendees = Attendee.where(trip_id: params[:trip_id])
    @attendees_ids = []
    @attendees.each do |attendee|
      @attendees_ids.push(attendee[:user_id])
    end
    @trip_length_night = (@trip.end_date - @trip.start_date).to_i
    
    # if a trip start & end location were entered - set variables to use for google API!
    if @trip.start_location
      @start_trip = @trip.start_location.to_s
      @start_trip_loc = @start_trip + ""
      @start_one = @trip.start_location
      @start_one = @start_one.gsub!(', ', '+') || @start_one
      @start_one = @start_one.gsub!('.', '') || @start_one
    end
    if @trip.end_location
      @end_trip = @trip.end_location.to_s
      @end_trip_loc = @end_trip + ""
      @end_one = @trip.end_location
      @end_one = @end_one.gsub!(', ', '+') || @end_one
      @end_one = @end_one.gsub!('.', '') || @end_one
    end
     
    # google API -> if start and end location are filled in, enter details into URI!
    if @trip.start_location != "" && @trip.end_location != ""
      @google_url = URI("https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{@start_one}&destinations=#{@end_one}&key=#{Rails.application.secrets.SECRET_GOOGLE_KEY}")
      @google_directions = URI("https://maps.googleapis.com/maps/api/directions/json?origin=#{@start_one}&destination=#{@end_one}&key=#{Rails.application.secrets.SECRET_GOOGLE_KEY}")
      response_directions = Net::HTTP.get(@google_directions)
      @google_result = JSON.parse(response_directions)
      @directions = ""
      response = Net::HTTP.get(@google_url)
      @result = JSON.parse(response)
      # if google API results are OK -> gather longitute/latitude and set google static image!
      if @google_result['status'] == "OK"
        @end_long = @google_result['routes'][0]['legs'][0]['end_location']['lng']
        @end_lat = @google_result['routes'][0]['legs'][0]['end_location']['lat']
        @start_lat = @google_result['routes'][0]['legs'][0]['start_location']['lat']
        @start_long = @google_result['routes'][0]['legs'][0]['start_location']['lng']
        @google_image = URI("https://maps.googleapis.com/maps/api/staticmap?center=#{@end_lat},#{@end_long}&zoom=14&size=600x300&markers=color:blue%7Clabel:S%7C#{@end_lat},#{@end_long}&key=#{Rails.application.secrets.SECRET_GOOGLE_KEY}")
        @response_image = Net::HTTP.get(@google_image)
      end
      # if google API results are OK -> set directions and duration/distance
      if @result
        if @result['rows'][0]['elements'][0]['status'] == "OK"
          @distance = @result['rows'][0]['elements'][0]['distance']['text']
          @duration = @result['rows'][0]['elements'][0]['duration']['text']
          @google_result['routes'][0]['legs'][0]['steps'].each do |step|
            @directions += "<li>"
            @directions += step['html_instructions']
            @directions += "</li>"
          end
        end
      end
    end
    
    @trip_attendees = @attendees.collect { |a| a.user }
    # Moderator is always the first attendee created -> setting moderator variable
    if @trip_attendees.present?
      @moderator = @trip_attendees.first.name
    end
    
    # CHECK IF WE ARE USING THIS
    @expenses = Expense.where(trip_id: params[:trip_id])
    @users = User.all
    @attendee_for_id = Attendee.where(user_id: @users.ids)
    @expenses_ids = @expenses.ids
    @payees = Payee.where(expense_id: @expenses_ids)
    @payees.each do |payee|
      @user_id = payee.user_id
      @payee_user = User.where(id: @user_id)
      @payee_user_ids = @payee_user.ids
      @attendee_user_for_finding_expense = Attendee.where(user_id: @payee_user_ids, trip_id: params[:trip_id])
      # not sure what this is for? --> Delete?
      @attendee_user_for_finding_expense.each do |attendee_for_balance|
      end
    end
    @expenses.each do |expense|
      @amount = expense.amount
      @expense_payees = @payees.where(expense_id: expense.id)
      @contributors_size = @expense_payees.size
      @payee_owes = (@amount / @contributors_size)
    end
    
    # logic for final 'owe statements' <-- owing balances
    if @trip.ended 
      @attendees_in_negative = Hash.new
      @attendees_in_positive = Hash.new
      @attendees.each do |attendee|
        if attendee[:balance_cents] > 0
          @attendees_in_positive[attendee[:user_id]] = attendee[:balance_cents] 
        else
          @attendees_in_negative[attendee[:user_id]] = attendee[:balance_cents]             
        end
      end
      @owe_statements = Array.new
      i = 0
      j = 0
      positiveKeys = @attendees_in_positive.keys
      negativeKeys = @attendees_in_negative.keys
      while i < @attendees_in_positive.length && j < @attendees_in_negative.length
        @user_who_owes = User.find(positiveKeys[i])
        @user_getting_paid = User.find(negativeKeys[j])
        delta = @attendees_in_positive[positiveKeys[i]] + @attendees_in_negative[negativeKeys[j]]
        if delta < 0
          @owe_statements.push("#{@user_who_owes.name} owes #{@user_getting_paid.name} $#{@attendees_in_positive[positiveKeys[i]].to_f/100}")
          @attendees_in_negative[negativeKeys[j]] = delta
          i += 1
        elsif delta > 0
          @owe_statements.push("#{@user_who_owes.name} owes #{@user_getting_paid.name} $#{-1 * @attendees_in_negative[negativeKeys[j]].to_f/100}")
          @attendees_in_positive[positiveKeys[i]] = delta
          j += 1
        else
          @owe_statements.push("#{@user_who_owes.name} owes #{@user_getting_paid.name} $#{@attendees_in_positive[positiveKeys[j]].to_f/100}")
          i += 1
          j += 1
        end
      end
    end
  end

  # GET /trips/new
  def new
    @new_trip = Trip.new
    @trip = Trip.new
    @trip_types = [["Weekend Getaway", 1], ["Boys Trip", 2], ["Bachelorette", 3], ["Road Trip", 4], ["Adventure", 5], ["Other", 6]]
  end
    
  # function used for edit trip modal!
  def inline_edit
    @attendees = Attendee.where(trip_id: params[:trip_id])
    @trip_attendees = @attendees.collect { |a| a.user }
    # Are we still using this file?
    respond_to do |format|
      format.js { render :file => "trips/inline_edit.js.erb" }
    end
  end
    
  # POST /trips
  # POST /trips.json
  def create
    @new_trip = Trip.create(trip_params)
    @trip = Trip.new(trip_params)
    @trip_types = [["Weekend Getaway", 1], ["Boys Trip", 2], ["Bachelorette", 3], ["Road Trip", 4], ["Adventure", 5], ["Other", 6]]
    # @first_attendee -> add the current user as an attendee automatically - when creating a trip
    @first_attendee = Attendee.create!([{trip_id: @new_trip.id, user_id: current_user.id, balance: 0}])
    # @attendees -> list of attendees only for current trip
    @attendees = Attendee.where(trip_id: params[:trip_id])
    @number_of_possible_attendees = @new_trip.number_of_possible_attendees
    @price_per_night = @new_trip.price_per_night
    @trip_length_night = (@new_trip.end_date - @new_trip.start_date).to_i
    @total_cost = @price_per_night.to_i * @trip_length_night.to_i
    respond_to do |format|
      @attendees_amount = @attendees.size
      if @new_trip.save
        # calculating total possible trip cost after trip has been created!
        @total_possible_accomodation_cost_per_person = @total_cost.to_i / @number_of_possible_attendees.to_i
        @new_trip.update_attribute(:total_possible_cost, @total_possible_accomodation_cost_per_person)
        @new_trip.update_attribute(:total_confirmed_cost, @total_confirmed_accomodation_cost_per_person)
        format.html { redirect_to "/trips/#{@new_trip.id}", notice: "Welcome to your trip's page!" }
        format.json { render :show, status: :created, location: @trip }
      else
        # format.html { redirect_to @new_trip }
        format.html { redirect_back(fallback_location: root_path) }
        format.json { render json: @new_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
          @trip_length_night = (@trip.end_date - @trip.start_date).to_i
          @price_per_night = @trip.price_per_night
          @total_cost = @price_per_night.to_i * @trip_length_night.to_i
          @attendees = Attendee.where(trip_id: params[:trip_id])
          @number_of_possible_attendees = @trip.number_of_possible_attendees
          @total_possible_accomodation_cost_per_person = @total_cost.to_i / @number_of_possible_attendees.to_i
          @total_confirmed_accomodation_cost_per_person = @total_cost.to_i / @attendees.count
          # if trip has been changed - update confirmed cost & total cost accordingly
          @trip.update_attribute(:total_confirmed_cost, @total_confirmed_accomodation_cost_per_person)
          @trip.update_attribute(:total_possible_cost, @total_possible_accomodation_cost_per_person)
          # Create accomodation cost on trip start! <-- if it exists already, it will not create again
          if Expense.exists?(trip_id: params[:trip_id], description: "Accomodation Cost") == false
            @accomodation_cost = Expense.new({
              trip_id: params[:trip_id],
              user_id: current_user.id,
              amount: @total_cost,
              description: "Accomodation Cost"
            })
          #add accomodation cost to balance of every attendee confirmed
          @accomodation_cost.save
            if @accomodation_cost.save
              @attendees.each do |attendee|
                Payee.create!({
                  user_id: attendee.user_id,
                  expense_id: @accomodation_cost.id
                })
              end
              @attendees.each do |attendee|
                # whomever did not click 'start' owes for accomodation - add cost to their balance
                if attendee.user_id != current_user.id
                  attendee.balance = attendee.balance.to_i + @total_confirmed_accomodation_cost_per_person
                  @attendee_balance = attendee.balance
                  attendee.update_attribute(:balance, @attendee_balance)
                else
                  # whomever clicked 'start' is the payee of the accomodation - minus cost from their balance
                  @payee_owed = @total_cost - @total_confirmed_accomodation_cost_per_person
                  attendee.balance = attendee.balance.to_i - @payee_owed
                  @attendee_balance = attendee.balance
                  attendee.update_attribute(:balance, @attendee_balance)
                end
              end
            end
        end
        format.html { redirect_to @trip, notice: 'Trip status has been updated.' }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { redirect_to @trip, notice: 'Unable to update trip' }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end 
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:trip_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:name, :accomodation_url, :price_per_night, :number_of_possible_attendees, :start_date, :end_date, :start_location, :end_location, :type_of_trip, :total_possible_cost, :total_confirmed_cost, :started, :ended)
    end
  end 
      


