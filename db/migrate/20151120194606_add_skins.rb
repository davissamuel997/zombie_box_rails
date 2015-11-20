class AddSkins < ActiveRecord::Migration
  def change
  	create_table :skins do |t|
  		t.string :name
  		t.integer :user_id
  		t.integer :kill_count
	  	t.integer :skinable_id
	  	t.string :skinable_type

  		t.timestamps
  	end

  	add_index :skins, :user_id
  end
end
