class EventsController < ApplicationController
  protect_from_forgery except: :create

  def create
    event = Event.new data: event_params.to_h
    if event.save
      render json: { message: :ok }
    else
      render status: 422, json: { message: :invalid }
    end
  end

  private

  def event_params
    params.permit 'Address', 'EmailType', 'Event', 'Timestamp'
  end
end
