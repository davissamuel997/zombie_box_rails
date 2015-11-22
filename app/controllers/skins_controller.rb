class SkinsController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:update_skin_stats]
  skip_before_filter :verify_authenticity_token, only: [:update_skin_stats]

  respond_to :json, :html

  def update_skin_stats
    response = Skin.update_skin_stats(params)

    render :json => response
  end

  def skin_params
    params.require(skin).permit(:name, :user_id, :kill_count)
  end

  private :skin_params
end
