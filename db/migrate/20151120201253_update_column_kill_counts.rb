class UpdateColumnKillCounts < ActiveRecord::Migration
  def change
  	change_column :users, :total_kills, :integer, :default => 0
  end
end
