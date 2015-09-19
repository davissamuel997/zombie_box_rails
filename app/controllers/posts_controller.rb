class PostsController < ApplicationController

  # skip_before_filter :authenticate_user!, only: []

  respond_to :json, :html

  def index
  end

  def get_posts
  	response = Post.get_posts(params)

  	respond_with response
  end

  def post_params
    params.require(:post).permit(:title, :post_date, :user_id, :text)
  end

  private :post_params
end
