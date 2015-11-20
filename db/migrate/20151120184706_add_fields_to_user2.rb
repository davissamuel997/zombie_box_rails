class AddFieldsToUser2 < ActiveRecord::Migration
  def change
  	add_column :users, :total_points, :integer

  	create_table :weapons do |t|
  		t.string :name
  		t.integer :damage
  		t.integer :ammo

  	end
  		t.timestamps
  end
end
