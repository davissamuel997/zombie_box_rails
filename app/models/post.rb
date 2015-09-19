class Post < ActiveRecord::Base

  belongs_to :user
  has_many :comments, as: :commentable

  def self.get_posts(options = {})
    data = {:errors => false}

    p 'hello world'

    data
  end

end
