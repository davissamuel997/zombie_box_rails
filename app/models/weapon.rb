class Weapon < ActiveRecord::Base

  belongs_to :weaponable, :polymorphic => true
  belongs_to :user

  def self.update_weapon_stats(options = {})
    data = {:errors => false}

    p 'weapon world'
    p options

    if options.present? && options.first.present? && options.first.first.present?
      weapon_params = JSON.parse(options.first.first)["weapon_params"]

      if weapon_params["weapon_id"].present? && weapon_params["weapon_id"].to_i > 0

        weapon = Weapon.find(weapon_params["weapon_id"])

        if weapon.present? && weapon.is_a?(Weapon)
          kill_count = weapon_params["kill_count"].present? && weapon_params["kill_count"].to_i > 0 ? weapon_params["kill_count"].to_i : weapon.try(:kill_count)
          damage     = weapon_params["damage"].present? && weapon_params["damage"].to_i > 0 ? weapon_params["damage"].to_i : weapon.try(:damage)
          ammo       = weapon_params["ammo"].present? && weapon_params["ammo"].to_i > 0 ? weapon_params["ammo"].to_i : weapon.try(:ammo)
          fire_rate  = weapon_params["fire_rate"].present? && weapon_params["fire_rate"].to_f >= 0 ? weapon_params["fire_rate"].to_f : weapon.try(:fire_rate)

          if weapon.update(kill_count: kill_count, damage: damage,
                           ammo: ammo, fire_rate: fire_rate)
            data[:weapon] = weapon.get_params
            data[:user]   = weapon.user.get_params
          else
            data[:errors] = true
          end
        else
          data[:errors] = true
        end
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
