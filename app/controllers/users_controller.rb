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
      response[:user] = current_user.get_params
    else
      response[:errors] = true
    end

    respond_with response
  end

  def update_user
    response = User.update_user(params)

    render :json => response
  end

  def get_users
    response = User.get_users(params)

    respond_with response
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number)
  end

  private :user_params
end
