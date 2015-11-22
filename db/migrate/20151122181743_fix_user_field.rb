class FixUserField < ActiveRecord::Migration
  def change
  	change_column :users, :total_points, :integer, :default => 0
  	change_column :users, :highest_round_reached, :integer, :default => 1
  end
end
