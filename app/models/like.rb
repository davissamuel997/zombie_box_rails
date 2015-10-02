class Like < ActiveRecord::Base

	belongs_to :likeable, :polymorphic => true

  validates :user_id, :likeable_id, presence: true,
    numericality: { only_integer: true }

  validates :likeable_type, presence: true,
    inclusion: { 
      in: %w(Post User),
      message: "%{value} is not a valid" 
    }

  validates :user_id, uniqueness: { scope: [ :likeable_type, :likeable_id ] }

end
