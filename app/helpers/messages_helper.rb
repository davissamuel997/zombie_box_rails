module MessagesHelper
	def get_message_recipients(message)
		@recipients = []
		message.recipients.each do |recipient|
			@recipients << "#{recipient.first_name} #{recipient.last_name} " if current_user.email != recipient.email
		end
		@recipients.join(', ')
	end

	def get_message_sender(message)
		"#{message.sender.first_name} #{message.sender.last_name}"
	end
end