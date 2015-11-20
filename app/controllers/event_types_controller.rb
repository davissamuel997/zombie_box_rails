class EventTypesController < ApplicationController

  respond_to :json, :html

  before_filter :set_event_type, :only => [:show, :edit, :update, :destroy]

	def index
		@event_types = EventType.all.order('name ASC')
	end

	def show
	end

	def new
		@event_type = EventType.new
	end

	def create
		@event_type = EventType.new(event_type_params)

		if @event_type.save
			redirect_to event_types_path
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @event_type.present? && @event_type.is_a?(OrganizationType) && @organization_type.update(organization_type_params)
			redirect_to event_types_path
		else
			render :edit
		end
	end

	def destroy
		@event_type.destroy

		redirect_to event_types_path
	end

	# /get_events
	def get_event_types
		response = EventType.get_event_types(params)

		respond_with response
	end

  def event_type_params
    params.require(:event_type).permit(:name, :description)
  end

  def set_event_type
		@event_type = EventType.find(params[:id])
  end

  private :event_type_params, :set_event_type
end
