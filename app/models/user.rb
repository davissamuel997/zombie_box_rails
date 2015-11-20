class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Mailboxer::Models::Messageable       
  acts_as_messageable 

  before_save :set_full_name

  has_many :posts
  has_many :likes
  has_many :friends, as: :friendable

  def set_full_name
    self.full_name = "#{self.first_name} #{self.last_name}"
  end

  def self.get_user_stats(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0
      user = User.find(options[:user_id])

      # Do stuff
    else
      data[:errors] = true
    end   

    data
  end

  def self.update_user_stats(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0
      user = User.find(options[:user_id])

      # Do stuff
    else
      data[:errors] = true
    end

    data
  end

  def self.update_user(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0 && options[:user_params].present?
      user = User.find options[:user_id]

      unless user.update(options[:user_params].permit(:first_name, :last_name, :email, :phone_number))
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end  

  def self.get_users(options = {})
    data = {:errors => false}

    page_num = (options[:page] || 1).to_i
    per_page = 10

    data[:users] = User.all.page(page_num).per(per_page).order('full_name ASC NULLS LAST').map{ |user| user.get_params(options[:current_user]) }

    data[:pagination] = User.pagination_data User.all.count, page_num, per_page

    data
  end

  def self.get_user_details(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0
      user = User.find(options[:user_id])

      data[:user] = user.get_params
    else
      data[:errors] = true
    end

    data
  end

  def get_user_inbox_messages
    notification_ids = Mailboxer::Receipt.find_by_sql("SELECT notification_id FROM mailboxer_receipts
                                                       WHERE receiver_id = #{self.id}
                                                         AND mailbox_type = 'inbox' 
                                                         AND trashed = false"
                                                      ).map(&:notification_id) 
    messages_array = Mailboxer::Message.where(id: notification_ids)
  end

  def get_user_outbox_messages
    notification_ids = Mailboxer::Receipt.find_by_sql("SELECT notification_id FROM mailboxer_receipts 
                                                         WHERE receiver_id = #{self.id} 
                                                           AND mailbox_type = 'sentbox' 
                                                           AND trashed = false"
                                                      ).map(&:notification_id) 
    messages_array = Mailboxer::Message.where(id: notification_ids)   
  end

  def get_user_trash_messages
    notification_ids = Mailboxer::Receipt.find_by_sql("SELECT notification_id FROM mailboxer_receipts 
                                                         WHERE receiver_id = #{self.id} 
                                                           AND trashed = 'true'"
                                                      ).map(&:notification_id) 
    messages_array = Mailboxer::Message.where(id: notification_ids) 
  end

  def self.get_recipient_list(current_user_id = nil)
    friends = []

    if current_user_id.present? && current_user_id > 0

      user = User.find(current_user_id)

      user.friends.where(is_pending: false).map{ |friend| friend.user }.sort_by{ |user| user.full_name }

    end

    friends
  end

  def self.verify_user_login(options = {})
    data = {:errors => false}

    if options[:email].present? && options[:email].size > 0 && options[:password].present? && options[:password].size > 0
      user = User.find_by_email(options[:email])

      if user.present? && user.is_a?(User) && user.valid_password?(options[:password])
        data[:user] = user.get_params
      else
        data[:errors] = true
      end
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

  def get_params(current_user = nil)
    {
      user_id:      id,
      first_name:   first_name,
      last_name:    last_name,
      full_name:    full_name,
      email:        email,
      phone_number: phone_number,
      friends:      friends.map{ |friend| friend.get_params },
      is_friend:    current_user.present? && current_user.is_a?(User) ? current_user.friends.any?{ |friend| friend.user_id == id } : nil
    }
  end
end
