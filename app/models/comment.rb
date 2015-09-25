include ActionView::Helpers::DateHelper

class Comment < ActiveRecord::Base

	belongs_to :commentable, :polymorphic => true

  after_create :set_post_date

  def set_post_date
    self.post_date = self.created_at.present? ? self.created_at : Time.now

    self.save
  end

  def get_post_time
    if self.created_at > Time.now.beginning_of_day
      post_time = "#{time_ago_in_words(self.created_at)} ago"
    else
      post_time = self.created_at.strftime("%b %d, %Y")
    end

    post_time
  end

  def get_user
  	if self.user_id.present? && self.user_id > 0
  		user = User.find(self.user_id)
  	else
  		user = nil
  	end

  	user
  end

end
