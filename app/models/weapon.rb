class Weapon < ActiveRecord::Base

  belongs_to :weaponable, :polymorphic => true
  belongs_to :user

  def get_params
    {
      weapon_id:       id,
      user_id:         user_id,
      damage:          damage,
      ammo:            ammo,
      name:            name,
      fire_rate:       fire_rate,
      kill_count:      kill_count,
      weaponable_id:   weaponable_id,
      weaponable_type: weaponable_type
    }
  end

end
