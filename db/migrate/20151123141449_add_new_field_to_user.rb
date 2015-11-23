class AddNewFieldToUser < ActiveRecord::Migration
  def change
  	add_column :users, :points_available, :integer, :default => 0
  end
end
