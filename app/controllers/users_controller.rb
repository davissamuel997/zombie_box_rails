class UsersController < ApplicationController

  # skip_before_filter :authenticate_user!, only: []

  respond_to :json, :html

  def welcome
  end

  def get_user_stats
  	response = User.get_user_stats(params)

  	render :json => response
  end

  def update_user_stats
  	response = User.update_user_stats(params)

  	render :json => response
  end

  def get_current_user
    response = {:errors => false}

    if current_user.present? && current_user.is_a?(User)
      response[:user] = {
        user_id:      current_user.id,
        first_name:   current_user.first_name,
        last_name:    current_user.last_name,
        email:        current_user.email,
        phone_number: current_user.phone_number
      }
    else
      response[:errors] = true
    end

    respond_with response
  end

  def update_user
    response = User.update_user(params)

    render :json => response
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number)
  end

  private :user_params
end
