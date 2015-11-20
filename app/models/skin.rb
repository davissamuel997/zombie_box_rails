class Skin < ActiveRecord::Base

  belongs_to :skinable, :polymorphic => true
  belongs_to :user

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
