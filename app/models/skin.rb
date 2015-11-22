class Skin < ActiveRecord::Base

  belongs_to :skinable, :polymorphic => true
  belongs_to :user

  def self.update_skin_stats(options = {})
    data = {:errors => false}

    p 'skin world'
    p options

    if options.present? && options.first.present? && options.first.first.present?
      skin_params = JSON.parse(options.first.first)["skin_params"]

      if skin_params["skin_id"].present? && skin_params["skin_id"].to_i > 0

        skin = Skin.find(skin_params["skin_id"])

        if skin.present? && skin.is_a?(Skin)
          kill_count = skin_params["kill_count"].present? && skin_params["kill_count"].to_i > 0 ? skin_params["kill_count"].to_i : skin.try(:kill_count)

          if skin.update(kill_count: kill_count)
            data[:skin] = skin.get_params
            data[:user] = skin.user.get_params
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
      skin_id:       id,
      user_id:       user_id,
      name:          name,
      kill_count:    kill_count,
      skinable_id:   skinable_id,
      skinable_type: skinable_type
    }
  end

end
