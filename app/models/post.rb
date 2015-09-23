class Post < ActiveRecord::Base

  belongs_to :user
  has_many :comments, as: :commentable

  def self.get_posts(options = {})
    data = {:errors => false}

    page_num = (options[:page] || 1).to_i
    per_page = 10

    posts = Post.all.page(page_num).per(per_page).order('created_at DESC')

    data[:posts] = posts.map { |post| {
        post_id:     post.id,
        title:       post.title,
        post_date:   post.post_date.present? ? post.post_date.strftime('%m/%d/%Y') : nil,
        text:        post.text,
        user:        post.user
      }
    }
    
    data[:pagination] = Post.pagination_data Post.all.count, page_num, per_page

    data
  end

  def self.create_post(options = {})
    data = {:errors => false}

    if options[:post_params].present? && options[:user_id].present? && options[:user_id].to_i > 0
      user = User.find(options[:user_id])

      post_params[:user_id] = options[:user_id]
      post_params[:post_date] = Date.today

      post = Post.new(post_params.permit(:user_id, :post_date, :title, :text))

      p post
      p 'hello world'
    else
      data[:errors] = true
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
