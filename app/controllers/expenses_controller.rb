class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

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
  end

  # POST /expenses
  # POST /expenses.json
  def create
    params.each do |key, value|
      # puts "Param #{key}: #{value}"
    end

    @expense = Expense.new(expense_params)
    @expense.trip_id = params[:trip_id]
    # @trip = Trip.where(id: @expense.trip_id)
    @trip = Trip.find(params[:trip_id].to_i)

    willing_payees = params[:expense][:payee][:user_id].select { |uid| uid.length > 0 }
    willing_payees.each do |pid|
      @expense.payees.new(user_id: pid)
      # TODO: this is kinda cavalier about the possibility of errors.  ha ha!
    end
    
    respond_to do |format|
      if @expense.save
        format.html { redirect_to @trip, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: trip_expenses_path }
      else
        format.html { redirect_to @trip, notice: 'Expense not successfully created.' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:trip_id, :user_id, :amount, :description, payees_attributes: [:id, :user_id, :expense_id])
    end
end
