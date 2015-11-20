class ChangeWeaponTable < ActiveRecord::Migration
  def change
    if table_exists? :weapons
      drop_table :weapons
    end

    if table_exists? :user_weapons
      drop_table :user_weapons
    end

    create_table :weapons do |t|
    	t.string :name
    	t.integer :damage
    	t.integer :ammo
    	t.integer :user_id
    	t.integer :kill_count

    	t.integer :friendable_id
    	t.string :friendable_type

    	t.timestamps
    end

    add_index :weapons, :user_id
    add_column :users, :total_kills, :integer
  end
end
