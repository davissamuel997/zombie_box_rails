class Friend < ActiveRecord::Base

	belongs_to :friendable, :polymorphic => true
	belongs_to :user

  validates :user_id, :friendable_id, presence: true,
    numericality: { only_integer: true }

  validates :friendable_type, presence: true,
    inclusion: { 
      in: %w(User),
      message: "%{value} is not a valid" 
    }

  validates :user_id, uniqueness: { scope: [ :friendable_type, :friendable_id ] }

  def get_params
  	{
  		friend_id:       id,
  		user_id:         user_id,
  		is_pending:      is_pending,
  		friend_date:     friend_date,
  		friendable_id:   friendable_id,
  		friendable_type: friendable_type
  	}
  end

end
