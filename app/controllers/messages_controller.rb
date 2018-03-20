class MessagesController < ApplicationController
  def create
    @trip = Trip.find(params[:trip_id].to_i)
    @message = Message.new(message_params)
    @message.trip_id = params[:trip_id]
    @message.user = current_user
    if @message.save
      ActionCable.server.broadcast 'messages',
        message: @message.content,
        user: @message.user.name,
        trip: @message.trip_id
      head :ok
    else 
      redirect_to @trip
    end
  end

  private

    def message_params
      params.require(:message).permit(:content, :trip_id)
    end
end
