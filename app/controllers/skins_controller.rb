class SkinsController < ApplicationController

  # skip_before_filter :authenticate_user!, only: []

  respond_to :json, :html

  def skin_params
    params.require(skin).permit(:name, :user_id, :kill_count)
  end

  private :skin_params
end
