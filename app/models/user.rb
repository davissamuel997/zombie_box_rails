class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Mailboxer::Models::Messageable       
  acts_as_messageable 

  before_save :set_full_name
  after_create :set_up_weapons
  after_create :set_up_skins

  has_many :posts
  has_many :likes
  has_many :friends, as: :friendable
  has_many :weapons, as: :weaponable
  has_many :skins, as: :skinable

  def set_full_name
    self.full_name = "#{self.first_name} #{self.last_name}"
  end

  def set_up_weapons
    self.weapons.create(name: "Gun", damage: 50,
                        ammo: 50, kill_count: 0,
                        user_id: self.id)

    self.weapons.create(name: "Shotgun", damage: 75,
                        ammo: 30, kill_count: 0,
                        user_id: self.id)

    self.weapons.create(name: "Knife", damage: 100,
                        kill_count: 0, user_id: self.id)

    self.weapons.create(name: "Crowbar", damage: 50,
                        kill_count: 0, user_id: self.id)
    self.weapons.create(name: "Turret", damage: 5,
                        kill_count: 0, user_id: self.id,
                        fire_rate: 2.0)
  end

  def set_up_skins
    self.skins.create(name: '00', kill_count: 0, user_id: self.id)
    self.skins.create(name: '01', kill_count: 0, user_id: self.id)
    self.skins.create(name: '02', kill_count: 0, user_id: self.id)
    self.skins.create(name: '03', kill_count: 0, user_id: self.id)
    self.skins.create(name: '04', kill_count: 0, user_id: self.id)
    self.skins.create(name: '05', kill_count: 0, user_id: self.id)
    self.skins.create(name: '06', kill_count: 0, user_id: self.id)
    self.skins.create(name: '07', kill_count: 0, user_id: self.id)
    self.skins.create(name: '08', kill_count: 0, user_id: self.id)
  end

  #Returning any kind of identification you want for the model
  def mailboxer_name
    "#{self.first_name} #{self.last_name}"
  end

  #Returning the email address of the model if an email should be sent for this object (Message or Notification).
  #If no mail has to be sent, return nil.
  def mailboxer_email(object)
    self.email
  end

  def self.get_user_stats(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0
      user = User.find(options[:user_id])

      # Do stuff
      data[:user] = user.get_params
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
    per_page = 25

    user_ids = User.all.map(&:id)

    final_sql_string = User.search_with_postgres(options, user_ids)

    if final_sql_string.present? && final_sql_string.size > 0
      data[:users] = User.where("id IN (?) AND (#{final_sql_string})", user_ids).page(page_num).per(per_page).order("full_name ASC NULLS LAST").map{ |user| user.get_params(options[:current_user]) }
    else
      data[:users] = User.where("id IN (?)", user_ids).page(page_num).per(per_page).order("full_name ASC NULLS LAST").map{ |user| user.get_params(options[:current_user]) }
    end

    data[:current_user] = options[:current_user].try(:get_params)

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

      friends = user.friends.where(is_pending: false).map{ |friend| friend.user }.sort_by{ |user| user.full_name }.map{ |user| [user.full_name, user.id] } 

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

  # Example - options[:user_params] = user = { user_id: 1, total_points: 104, total_kills: 299, weapons: [{ weapon_id: 30, kill_count: 15, damage: 65, ammo: 99 }, { weapon_id: 32, kill_count: 15, damage: 100 }], skins: [{ skin_id: 64, kill_count: 345 }, { skin_id: 72, kill_count: 425 }] }
  def self.update_all_user_details(options = {})
    data = {:errors => false}

    p 'hello world'
    p options

    if options.present? && options.first.present? && options.first.first.present?
      user_params = JSON.parse(options.first.first)["user_params"]

      if user_params["user_id"].present? && user_params["user_id"].to_i > 0

        user = User.find(user_params["user_id"])

        if user.present? && user.is_a?(User)
          total_points          = user_params["total_points"].present? && user_params["total_points"].to_i > 0 ? user_params["total_points"].to_i : user.try(:total_points)
          total_kills           = user_params["total_kills"].present? && user_params["total_kills"].to_i > 0 ? user_params["total_kills"].to_i : user.try(:total_kills)
          green                 = user_params["green"].present? && user_params["green"].to_f >= 0 ? user_params["green"].to_f : user.try(:green)
          red                   = user_params["red"].present? && user_params["red"].to_f >= 0 ? user_params["red"].to_f : user.try(:red)
          blue                  = user_params["blue"].present? && user_params["blue"].to_f >= 0 ? user_params["blue"].to_f : user.try(:blue)
          points_available      = user_params["points_available"].present? && user_params["points_available"].to_i > 0 ? user_params["points_available"].to_i : user.try(:points_available)
          highest_round_reached = user_params["highest_round_reached"].present? && user_params["highest_round_reached"].to_i > 0 ? user_params["highest_round_reached"].to_i : user.try(:highest_round_reached)

          if user.update(total_points: total_points, total_kills: total_kills,
                         green:        green, red: red,
                         blue:         blue, points_available: points_available,
                         highest_round_reached: highest_round_reached)

            data[:user] = user.get_params
          else
            data[:errors] = true
          end
        else
          data[:errors] = true
        end
      else
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end

  def self.get_leaderboard_data(options = {})
    data = {:errors => false}

    page_num           = (options[:page] || 1).to_i
    per_page           = 25
    sort_by            = options[:sort_by].present? && options[:sort_by].size > 0 ? options[:sort_by] : 'total_kills'
    sortable_direction = options[:sortable_direction].present? && options[:sortable_direction].size > 0 ? options[:sortable_direction] : 'DESC'

    data[:total_users] = User.all.count
    data[:users]       = User.all.order("#{sort_by} #{sortable_direction} NULLS LAST").page(page_num).per(per_page).map{ |user| user.get_params }
    # data[:users]      = User.all.order('total_kills DESC NULLS LAST').page(page_num).per(per_page).map{ |user| user.get_params }
    data[:pagination]  = User.all.count, page_num, per_page

    data
  end

  def self.request_friend(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0 && options[:new_friend_user_id].present? && options[:new_friend_user_id].to_i > 0
      user = User.find(options[:user_id])

      friend_user = User.find(options[:new_friend_user_id])

      new_friend = user.friends.new(user_id: friend_user.id, friend_date: Date.today,
                                    is_pending: false)

      new_friend_2 = friend_user.friends.new(user_id: user.id, friend_date: Date.today,
                                             is_pending: false)

      if new_friend.save && new_friend_2.save
        page_num = (options[:page] || 1).to_i
        per_page = 10

        data[:users] = User.all.page(page_num).per(per_page).order('full_name ASC NULLS LAST').map{ |u| u.get_params(user) }

        data[:pagination] = User.pagination_data User.all.count, page_num, per_page
      else
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end

  def self.remove_friend(options = {})
    data = {:errors => false}

    if options[:user_id].present? && options[:user_id].to_i > 0 && options[:remove_friend_user_id].present? && options[:remove_friend_user_id].to_i > 0
      user = User.find(options[:user_id])

      friend_user = User.find(options[:remove_friend_user_id])

      if user.present? && user.is_a?(User) && friend_user.present? && friend_user.is_a?(User) && user.friends.where(user_id: friend_user.id).first && friend_user.friends.where(user_id: user.id).first && user.friends.where(user_id: friend_user.id).first.destroy && friend_user.friends.where(user_id: user.id).first.destroy
        page_num = (options[:page] || 1).to_i
        per_page = 10

        data[:users] = User.all.page(page_num).per(per_page).order('full_name ASC NULLS LAST').map{ |u| u.get_params(user) }

        data[:pagination] = User.pagination_data User.all.count, page_num, per_page
      else
        data[:errors] = true
      end
    else
      data[:errors] = true
    end

    data
  end

  def self.search_with_postgres(options = {}, user_ids)

    sql_string = []

    users = []

    if options[:full_name].present? && options[:full_name].size > 0
      sql_string << "(full_name ILIKE '%#{options[:full_name]}%')"
    end

    if options[:email].present? && options[:email].size > 0
      sql_string << "(email ILIKE '%#{options[:email]}%')"
    end

    if options[:phone_number].present? && options[:phone_number].size > 0
      sql_string << "(phone_number ILIKE '%#{options[:phone_number]}%')"
    end

    final_sql_string = sql_string.count > 1 ? sql_string.join(' AND ') : sql_string[0]
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
      user_id:               id,
      first_name:            first_name,
      last_name:             last_name,
      full_name:             full_name,
      email:                 email,
      phone_number:          phone_number,
      green:                 green,
      red:                   red,
      blue:                  blue,
      friends:               friends.map{ |friend| friend.get_params },
      is_friend:             current_user.present? && current_user.is_a?(User) ? current_user.friends.any?{ |friend| friend.user_id == id } : nil,
      total_points:          total_points,
      total_kills:           total_kills,
      points_available:      points_available,
      highest_round_reached: highest_round_reached,
      weapons:               weapons.order('name ASC').map{ |weapon| weapon.get_params },
      skins:                 skins.order('name ASC').map{ |skin| skin.get_params },
      top_weapon:            weapons.order('kill_count DESC').first.try(:get_params),
      top_skin:              skins.order('kill_count DESC').first.try(:get_params)
    }
  end
end
