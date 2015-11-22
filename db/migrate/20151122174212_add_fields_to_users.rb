class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :highest_round_reached, :integer

  	add_column :weapons, :fire_rate, :float
  end
end
