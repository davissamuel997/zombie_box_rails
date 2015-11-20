class Weapon < ActiveRecord::Base

  belongs_to :weaponable, :polymorphic => true
  belongs_to :user

  validates :user_id, :weaponable_id, presence: true,
    numericality: { only_integer: true }

  validates :weaponable_type, presence: true,
    inclusion: { 
      in: %w(User),
      message: "%{value} is not a valid" 
    }

  validates :user_id, uniqueness: { scope: [ :weaponable_type, :weaponable_id ] }

  def get_params
    {
      weapon_id:       id,
      user_id:         user_id,
      damage:          damage,
      ammo:            ammo,
      kill_count:      kill_count,
      weaponable_id:   weaponable_id,
      weaponable_type: weaponable_type
    }
  end

end
