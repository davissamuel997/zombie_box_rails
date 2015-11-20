class Event < ActiveRecord::Base

	belongs_to :event_type

  has_many :comments, as: :commentable

  def self.get_events(options = {})
  	data = {:errors => false}

  	user = options[:current_user]

  	if user.present? && user.is_a?(User)
      # Need to adjust query
  		data[:events] = Event.all.order('start_date DESC').map{ |event| event.get_params }
  	else
  		data[:errors] = true
  	end

  	data
  end

  def self.get_event_dropdowns(options = {})
  	data = {:errors => false}

  	if options[:organization_id].present? && options[:organization_id].to_i > 0
  		organization = Organization.find(options[:organization_id])

  		data[:event_statuses] = EventStatus.where(university_id: organization.university_id).order('name ASC').map{ |event_status| event_status.get_params }
  		data[:event_types]    = EventType.where(university_id: organization.university_id).order('name ASC').map{ |event_type| event_type.get_params }
  		data[:states]         = Carmen::Country.coded('US').subregions.map{ |state| state.name } 
  	else
  		data[:errors] = true
  	end

  	data
  end

  def self.get_countries(options = {})
    data = {:errors => false}

    if options[:campaign_id].present? && options[:campaign_id].to_i > 0
      campaign = Campaign.find(options[:campaign_id])

      data[:countries] = IsoCountryCodes.for_select.map { |country| {name: country[0], code: country[1]} if country[0].present? && country[1].present? }
    else
      data[:errors] = true
    end

    data
  end

  def self.create_event(options = {}, need_parse = false)
    data = {:errors => false}

    if options[:event_params].present?
      event_params = need_parse ? JSON.parse(options[:event_params]) : options[:event_params]

      event = Event.new(event_params)

      if event.save
        data[:event_id] = event.id
      else
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end

  def self.create_event_comment(options = {})
    data = {:errors => false}

    if options[:event_id].present? && options[:event_id].to_i > 0 && options[:comment_text].present? && options[:comment_text].size > 0 && options[:user_id].present? && options[:user_id].to_i > 0
      event = Event.find(options[:event_id])

      new_comment = event.comments.new(user_id: options[:user_id], text: options[:comment_text])

      if new_comment.save
        data[:comments] = event.comments.order('created_at ASC').map{ |comment| comment.get_params }
      else
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end

	def get_params
		{
			event_id:        id,
			name:            name,
			event_type_id:   event_type_id,
      event_type_name: event_type.try(:name),
			description:     description,
			start_time:      start_time.present? ? start_time.strftime('%I:%M %p') : nil,
      end_time:        end_time.present? ? end_time.strftime('%I:%M %p') : nil,
      start_date:      start_date.present? ? start_date.strftime('%m/%d/%Y') : nil,
      end_date:        end_date.present? ? end_date.strftime('%m/%d/%Y') : nil,
      comments:        self.comments.order('created_at ASC').map{ |comment| comment.get_params } 
		}
	end

end
