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
    @trips = Trip.all
    @expense = Expense.new
    @attendees = Attendee.where(trip_id: params[:id])
    @attendees_ids = []
    @trip_length_night = (@trip.end_date - @trip.start_date).to_i
    
    @attendees.each do |a|
      @attendees_ids.push(a.user_id)
    end

    @trip_attendees = @attendees.collect { |a| a.user }
    @expenses = Expense.where(trip_id: params[:id])
    @users = User.all
    @attendee_for_id = Attendee.where(user_id: @users.ids)
    @expenses_ids = @expenses.ids

    @payees = Payee.where(expense_id: @expenses_ids)
  
    @payees.each do |payee|
      @user_id = payee.user_id
      @payee_user = User.where(id: @user_id)
      @payee_user_ids = @payee_user.ids
      @attendee_user_for_finding_expense = Attendee.where(user_id: @payee_user_ids, trip_id: params[:id])
      @attendee_user_for_finding_expense.each do |attendee_for_balance|
      end
    end

    @expenses.each do |expense|
      @amount = expense.amount
      @expense_payees = @payees.where(expense_id: expense.id)
      @contributors_size = @expense_payees.size
      @payee_owes = (@amount / @contributors_size)
    end

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

          @attendees_in_positive.each do |positive|
            @attendees_in_negative.each do |negative|
              if positive[1] <= negative[1].abs
                @temp = positive[1]/100
                negative[1] = negative[1] - @temp
                @user_who_owes = User.find(positive[0])
                @user_getting_paid = User.find(negative[0])
                @owe_statements.push("#{@user_who_owes.name} owes #{@user_getting_paid.name} #{@temp}")
              end
            end
          end

        end
      end

  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(trip_params)
    @attendees = Attendee.where(trip_id: params[:id])
    @number_of_possible_attendees = @trip.number_of_possible_attendees
    @price_per_night = @trip.price_per_night
    @trip_length_night = (@trip.end_date - @trip.start_date).to_i
    @total_cost = @price_per_night.to_i * @trip_length_night.to_i
    
    respond_to do |format|
      @attendees_amount = @attendees.size
      if @trip.save
        @total_possible_accomodation_cost_per_person = @total_cost.to_i / @number_of_possible_attendees.to_i
        puts "TOTAL POSSIBLE COST"
        puts @total_possible_accomodation_cost_per_person
        @trip.update_attribute(:total_possible_cost, @total_possible_accomodation_cost_per_person)
        @trip.update_attribute(:total_confirmed_cost, @total_confirmed_accomodation_cost_per_person)
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        if @trip.started 
          @trip_length_night = (@trip.end_date - @trip.start_date).to_i
          @price_per_night = @trip.price_per_night
          @total_cost = @price_per_night.to_i * @trip_length_night.to_i
          @attendees = Attendee.where(trip_id: params[:id])
          @total_confirmed_accomodation_cost_per_person = @total_cost.to_i / @attendees.count
          if Expense.exists?(trip_id: params[:id], description: "Accomodation Cost") == false
            @accomodation_cost = Expense.new({
              trip_id: params[:id],
              user_id: current_user.id,
              amount: @total_cost,
              description: "Accomodation Cost"
            })
          

          #add amount to balance
          @accomodation_cost.save
            if @accomodation_cost.save
              @attendees.each do |attendee|
                if attendee.user_id != current_user.id
                  attendee.balance = attendee.balance.to_i + @total_confirmed_accomodation_cost_per_person
                  @attendee_balance = attendee.balance
                  attendee.update_attribute(:balance, @attendee_balance)
                else
                  @payee_owed = @total_cost - @total_confirmed_accomodation_cost_per_person
                  attendee.balance = attendee.balance.to_i - @payee_owed
                  @attendee_balance = attendee.balance
                  attendee.update_attribute(:balance, @attendee_balance)
                end
              end
            end
          end
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end
end


  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: 'Trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:name, :accomodation_url, :price_per_night, :number_of_possible_attendees, :start_date, :end_date, :total_possible_cost, :total_confirmed_cost, :started, :ended)
    end

end 
  
