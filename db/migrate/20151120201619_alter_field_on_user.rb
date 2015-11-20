class AlterFieldOnUser < ActiveRecord::Migration
  def change
  	change_column :users, :total_points, :integer, :default => 0
  end
end
