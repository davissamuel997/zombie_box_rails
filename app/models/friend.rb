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

end
