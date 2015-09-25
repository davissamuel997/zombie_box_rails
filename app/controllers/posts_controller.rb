class PostsController < ApplicationController

  # skip_before_filter :authenticate_user!, only: []

  respond_to :json, :html

  def index
  end

  def get_posts
  	response = Post.get_posts(params)

  	respond_with response
  end

  def create_post
    params[:user_id] = current_user.id

    response = Post.create_post(params)

    render :json => response
  end

  def create_post_comment
    params[:user_id] = current_user.id

    response = Post.create_post_comment(params)

    render :json => response
  end

  def post_params
    params.require(:post).permit(:title, :post_date, :user_id, :text)
  end

  private :post_params
end
