class WeaponsController < ApplicationController

  # skip_before_filter :authenticate_user!, only: []

  respond_to :json, :html

  def weapon_params
    params.require(:weapon).permit(:name, :damage, :ammo, :user_id, :kill_count)
  end

  private :uweapon_params
end
