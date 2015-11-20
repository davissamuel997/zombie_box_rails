class EventsController < ApplicationController

  respond_to :json, :html

  before_filter :set_event, :only => [:show, :edit, :update, :destroy]

	def index
	end

	def show
	end

	def new
		@event = Event.new
	end

	def create
		@event = Event.new(event_params)

		if @event.save
			redirect_to events_path
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @event.present? && @event.is_a?(Event) && @event.update(event_params)
			redirect_to events_path
		else
			render :edit
		end
	end

	def destroy
		@event.destroy

		redirect_to events_path
	end

	# /get_events
	def get_events
		params[:current_user] = current_user

		response = Event.get_events(params)

		respond_with response
	end

	def get_event_dropdowns
		response = Event.get_event_dropdowns(params)

		respond_with response
	end

	def create_event
		response = Event.create_event(params, true)

		respond_with response
	end

	def create_event_comment
    params[:user_id] = current_user.id

    response = Event.create_event_comment(params)

    respond_with response
	end

  def event_params
    params.require(:event).permit(:name, :description, :event_type_id, :start_time, :end_time, :start_date, :end_date)
  end

  def set_event
		@event = Event.find(params[:id])
  end

  private :event_params, :set_event
end
