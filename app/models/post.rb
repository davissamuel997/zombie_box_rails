include ActionView::Helpers::DateHelper

class Post < ActiveRecord::Base

  belongs_to :user
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable

  after_create :set_post_date

  def set_post_date
    self.post_date = self.created_at.present? ? self.created_at : Time.now

    self.save
  end

  def get_post_time
    if self.created_at > Time.now.beginning_of_day
      post_time = "#{time_ago_in_words(self.created_at)} ago"
    else
      post_time = self.created_at.strftime("%b %d, %Y")
    end

    post_time
  end

  def get_like_text
    likes = self.likes

    if likes.present? && likes.count > 0
      like_text = "#{likes.count} like"

      like_text += "s" if likes.count > 1
    else
      like_text = nil
    end

    like_text
  end

  def user_like_post(user_id = nil)
    if user_id.present? && user_id.to_i > 0
      like_ids = self.likes.map(&:user_id)

      is_included = like_ids.include? user_id
    else
      is_included = false
    end

    is_included
  end

  def make_object(user_id = nil)
    {
      post_id:     self.id,
      title:       self.title,
      post_date:   self.post_date.present? ? self.post_date.strftime('%m/%d/%Y') : nil,
      text:        self.text,
      user:        self.user,
      post_time:   self.get_post_time,
      comments:    self.comments.order('created_at ASC').map{ |comment| {
          comment_id: comment.id,
          user:       comment.get_user,
          text:       comment.text,
          post_date:  comment.post_date,
          post_time:  comment.get_post_time
        } 
      },
      like_count: self.likes.count,
      like_text:  self.get_like_text,
      user_likes_post: self.user_like_post(user_id)
    }
  end

  def self.get_posts(options = {})
    data = {:errors => false}

    page_num = (options[:page] || 1).to_i
    per_page = 10

    posts = Post.all.page(page_num).per(per_page).order('created_at DESC')

    data[:posts] = posts.map { |post| post.make_object(options[:user_id]) }
    
    data[:pagination] = Post.pagination_data Post.all.count, page_num, per_page

    data
  end

  def self.create_post(options = {})
    data = {:errors => false}

    if options[:post_params].present? && options[:user_id].present? && options[:user_id].to_i > 0
      user = User.find(options[:user_id])

      options[:post_params][:user_id] = options[:user_id]

      post = Post.new(options[:post_params].permit(:user_id, :post_date, :title, :text))

      if post.save
        data[:data] = Post.get_posts
      else
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end

  def self.create_post_comment(options = {})
    data = {:errors => false}

    if options[:post_id].present? && options[:post_id].to_i > 0 && options[:comment_text].present? && options[:comment_text].size > 0 && options[:user_id].present? && options[:user_id].to_i > 0
      post = Post.find(options[:post_id])

      new_comment = post.comments.new(user_id: options[:user_id], text: options[:comment_text])

      if new_comment.save
        data[:comments] = post.comments.order('created_at ASC').map{ |comment| {
            comment_id: comment.id,
            user:       comment.get_user,
            text:       comment.text,
            post_date:  comment.post_date,
            post_time:  comment.get_post_time
          } 
        }
      else
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end

  def self.like_post(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0 && options[:post_id].present? && options[:post_id].to_i > 0
      post = Post.find(options[:post_id])

      like = post.likes.new(user_id: options[:user_id])

      if like.save
        data[:post] = post.make_object(options[:user_id])
      else
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end

  def self.unlike_post(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0 && options[:post_id].present? && options[:post_id].to_i > 0
      post = Post.find(options[:post_id])

      like = post.likes.where(user_id: options[:user_id]).first

      if like.present? && like.is_a?(Like) && like.destroy
        data[:post] = post.make_object(options[:user_id])
      else
        data[:errors] = true
      end
    else
      data[:errors] = false
    end

    data
  end

  # This paginates all of the data for the response of the js.
  def self.pagination_data element_count, current_page, results_per_page
    page  = current_page.to_i
    pages = (element_count / results_per_page.to_f).ceil

    if pages <= 1
      pages = 1
      relevant_pages = []
    else
      # If possible, add the two previous and two next pages to the 'relevant pages' array
      previous_pages = page - 2 < 1 ? (1..page).to_a : ( (page - 2)..page ).to_a
      next_pages     = page + 2 > pages ? ( (page+1)..pages ).to_a : ( (page+1)..(page + 2) ).to_a
      relevant_pages = previous_pages + next_pages

      # Add the first and last page to the 'relevant pages' array if they are not present
      relevant_pages.unshift(1) unless relevant_pages.first == 1
      relevant_pages << pages   unless relevant_pages.last == pages
    end

    { total_items: element_count, pages: pages, relevant_pages: relevant_pages }
  end

end
