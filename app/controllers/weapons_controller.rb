class WeaponsController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: [:update_weapon_stats]

  respond_to :json, :html

  def update_weapon_stats
    response = Weapon.update_weapon_stats(params)

    render :json => response
  end

  def weapon_params
    params.require(:weapon).permit(:name, :damage, :ammo, :user_id, :kill_count)
  end

  private :weapon_params
end
