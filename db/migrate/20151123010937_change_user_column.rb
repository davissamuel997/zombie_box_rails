class ChangeUserColumn < ActiveRecord::Migration
  def change
  	change_column :users, :green, :float, :default => 0.0
  	change_column :users, :red, :float, :default => 0.0
  	change_column :users, :blue, :float, :default => 0.0
  end
end
