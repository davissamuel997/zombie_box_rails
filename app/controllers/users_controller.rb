class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:get_user_stats]
  skip_before_filter :verify_authenticity_token, only: [:update_all_user_details]

  before_filter :set_user, :only => [:show, :edit, :update]

  respond_to :json, :html

  def welcome
  end

  def show
  end

  def edit
  end

  def leaderboards
  end

  def update
    if @user.present? && @user.is_a?(User) && @user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
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
    params[:current_user] = current_user

    response = User.get_users(params)

    respond_with response
  end

  def get_user_details
    params[:user_id] = current_user.try(:id)

    response = User.get_user_details(params)

    respond_with response
  end

  def verify_user_login
    response = User.verify_user_login(params)

    render :json => response
  end

  def update_all_user_details
    response = User.update_all_user_details(params)

    render :json => response
  end

  def get_leaderboard_data
    response = User.get_leaderboard_data(params)

    respond_with response
  end

  def request_friend
    params[:user_id] = current_user.try(:id)

    response = User.request_friend(params)

    respond_with response
  end

  def remove_friend
    params[:user_id] = current_user.try(:id)

    response = User.remove_friend(params)

    respond_with response
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :role_ids, :total_points, :total_kills)
  end

  def set_user
    @user = current_user
  end

  private :user_params, :set_user
end
