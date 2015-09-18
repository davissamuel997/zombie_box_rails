class PostsController < ApplicationController

  # skip_before_filter :authenticate_user!, only: []

  respond_to :json, :html

  def index
  end

  def post_params
    params.require(:post).permit(:title, :post_date, :user_id, :text)
  end

  private :post_params
end
