class FixTypo < ActiveRecord::Migration
  def change
  	remove_column :weapons, :friendable_id
  	remove_column :weapons, :friendable_type

  	add_column :weapons, :weaponable_id, :integer
  	add_column :weapons, :weaponable_type, :string
  end
end
