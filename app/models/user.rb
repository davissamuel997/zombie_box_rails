class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :set_full_name

  has_many :posts
  has_many :likes

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

    data[:users] = User.all.order('email ASC NULLS LAST')

    data
  end
end
