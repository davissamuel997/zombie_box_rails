class AddColorFieldsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :green, :float
  	add_column :users, :red, :float
  	add_column :users, :blue, :float
  end
end
