class EventType < ActiveRecord::Base

	has_many :events

	def get_params
		{
			event_type_id: id,
			name:          name,
			description:   description
		}
	end

	def self.get_event_types(options = {})
		data = {:errors => false}

		data[:event_types] = EventType.all.order('name ASC')

		data
	end

end
