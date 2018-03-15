class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy, :inline_edit]
  before_action :update_balance, only: [:destroy, :update]
  # need to create a proper update balance function on update
  # after_action :update_balance_after_edit, only: [:inline_edit]

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.all
  end
  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end
  # GET /expenses/new
  def new
    @expense = Expense.new
  end
  # GET /expenses/1/edit
  def edit
    @attendees = Attendee.where(trip_id: params[:id])
    @trip_attendees = @attendees.collect { |a| a.user }
    respond_to do |format|
        format.html {redirect_to @trip }
        format.json { render :show, status: :created, location: trip_expenses_path }
     end
  end
  # POST /expenses
  # POST /expenses.json
  def create
    params.each do |key, value|
      # puts "Param #{key}: #{value}"
    end
    @expense = Expense.new(expense_params)
    @expense.trip_id = params[:trip_id]
    @trip = Trip.find(params[:trip_id].to_i)
    @amount = @expense.amount
    # create hash to store split portions for each user
    split_hash = Hash.new()
    if params[:split_type] == "split_by_amount"
      passed_split = params[:expense][:payee][:split]
      portions = []
      passed_split.each do |id, obj|
        portions.push(obj[:portion].to_f)
      end
      portion_sum = 0
      portions.each { |a| portion_sum += a }
      if portion_sum != @amount.to_f
        redirect_to @trip, notice: 'Error: expense amount does not equal sum of portions entered.' 
        return
      end
      passed_split.each do |id, obj|
        @expense.payees.new(user_id: id)
        split_hash[id] = Money.new(obj[:portion].to_f * 100, 'USD')
      end
    else
      @willing_payees = params[:expense][:payee][:user_id].select { |uid| uid.length > 0 }
      @payee_size = @willing_payees.size
      @willing_payees.each do |pid|
        @expense.payees.new(user_id: pid)
        split_hash[pid] = (@amount / @payee_size) #/
        # TODO: this is kinda cavalier about the possibility of errors.  ha ha!
      end
    end

    respond_to do |format|
      if @expense.save
        # go through hash and calculate user's owed balance
        split_hash.each do |key, value|
          @user_id = key
          @payee_user = User.where(id: @user_id)
          @payee_user_ids = @payee_user.ids
          @attendee_user_for_finding_expense = Attendee.where(user_id: @payee_user_ids, trip_id: params[:trip_id].to_i)
          @attendee_user_for_finding_expense.each do |attendee_for_balance|
            attendee_for_balance.balance += value
            @attendee_balance = attendee_for_balance.balance
            attendee_for_balance.update_attribute(:balance, @attendee_balance)
          end
        end
        # deduct amount paid by expense user
        @attendee_payer_of_expense = Attendee.where(user_id: @expense.user_id, trip_id: params[:trip_id].to_i).first
        @payer_balance = @attendee_payer_of_expense.balance - @expense.amount
        @attendee_payer_of_expense.update_attribute(:balance, @payer_balance)
        format.html { redirect_to @trip, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: trip_expenses_path }
      else
        format.html { redirect_to @trip, flash[:alert] = 'Expense not successfully created.' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    @expense = Expense.find(params[:id])
    if @expense
      @expense.destroy
    end
    @trip = Trip.find(params[:trip_id].to_i)
    params.each do |key, value|
      # puts "Param #{key}: #{value}"
    end
    @updated_expense = Expense.new(expense_params)

    @updated_expense.trip_id = params[:trip_id]
    @trip = Trip.find(params[:trip_id].to_i)
    @amount = @updated_expense.amount
    # create hash to store split portions for each user
    split_hash = Hash.new()
    if params[:split_type] == "split_by_amount"
      passed_split = params[:expense][:payee][:split]
      portions = []
      passed_split.each do |id, obj|
        portions.push(obj[:portion].to_f)
      end
      portion_sum = 0
      portions.each { |a| portion_sum += a }
      if portion_sum != @amount.to_f
        redirect_to @trip, notice: 'Error: expense amount does not equal sum of portions entered.' 
        return
      end
      passed_split.each do |id, obj|
        @updated_expense.payees.new(user_id: id)
        split_hash[id] = Money.new(obj[:portion].to_f * 100, 'USD')
      end
    else
      @willing_payees = params[:expense][:payee][:user_id].select { |uid| uid.length > 0 }
      @payee_size = @willing_payees.size
      @willing_payees.each do |pid|
        @updated_expense.payees.new(user_id: pid)
        split_hash[pid] = (@amount / @payee_size) #/
        # TODO: this is kinda cavalier about the possibility of errors.  ha ha!
      end
    end

    respond_to do |format|
      if @updated_expense.save
        # go through hash and calculate user's owed balance
        split_hash.each do |key, value|
          @user_id = key
          @payee_user = User.where(id: @user_id)
          @payee_user_ids = @payee_user.ids
          @attendee_user_for_finding_expense = Attendee.where(user_id: @payee_user_ids, trip_id: params[:trip_id].to_i)
          @attendee_user_for_finding_expense.each do |attendee_for_balance|
            attendee_for_balance.balance += value
            @attendee_balance = attendee_for_balance.balance
            attendee_for_balance.update_attribute(:balance, @attendee_balance)
          end
        end
        # deduct amount paid by expense user
        @attendee_payer_of_expense = Attendee.where(user_id: @updated_expense.user_id, trip_id: params[:trip_id].to_i).first
        @payer_balance = @attendee_payer_of_expense.balance - @updated_expense.amount
        @attendee_payer_of_expense.update_attribute(:balance, @payer_balance)
        format.html { redirect_to @trip, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: trip_expenses_path }
      else
        format.html { redirect_to @trip, notice: 'Expense not successfully created.' }
        format.json { render json: @updated_expense.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @trip = Trip.find(params[:trip_id].to_i)
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to @trip, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def inline_edit
    # @attendees = Attendee.where(trip_id: params[:id])
    @attendees = @expense.payees.all
    @trip_attendees = @attendees.collect { |a| a.user }
    respond_to do |format|
      format.js { render :file => "trips/inline_edit.js.erb" } # create a file named inline_edit.js.erb
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
      @trip = Trip.find(params[:trip_id].to_i)
    end
   
    def update_balance
      @willing_payees = @expense.payees.all
      # TODO: this is kinda cavalier about the possibility of errors.  ha ha!
      @amount = @expense.amount
      p @willing_payees
      @payee_size = @willing_payees.count
      puts @payee_size
      @payee_owes = (@amount / @payee_size) 
      @willing_payees.each do |payee|
        @user_id = payee.user_id
        @payee_user = User.where(id: @user_id)
        @payee_user_ids = @payee_user.ids
        @attendee_user_for_finding_expense = Attendee.where(user_id: @payee_user_ids, trip_id: params[:trip_id].to_i)
        @attendee_user_for_finding_expense.each do |attendee_for_balance|
          attendee_for_balance.balance -= @payee_owes
          @attendee_balance = attendee_for_balance.balance
          attendee_for_balance.update_attribute(:balance, @attendee_balance)
        end
      end

        @attendee_payer_of_expense = Attendee.where(user_id: @expense.user_id, trip_id: params[:trip_id].to_i).first
        @gets_back = (@payee_owes * @payee_size)
        @payer_balance = @attendee_payer_of_expense.balance + @gets_back
        @attendee_payer_of_expense.update_attribute(:balance, @payer_balance)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:trip_id, :user_id, :amount, :description, payees_attributes: [:id, :user_id, :expense_id])
    end
end
        