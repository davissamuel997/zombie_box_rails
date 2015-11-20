class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  def self.get_assignable_roles
    Role.all
  end

  def get_params
  	{
  		role_id:       id,
  		name:          name,
  		resource_id:   resource_id,
  		resource_type: resource_type
  	}
  end
end
