class CreateUserWeapon < ActiveRecord::Migration
  def change
    create_table :user_weapons do |t|
    	t.integer :user_id
    	t.integer :weapon_id

    	t.integer :kill_count

    	t.timestamps
    end

    add_index :user_weapons, :user_id
    add_index :user_weapons, :weapon_id
  end
end
