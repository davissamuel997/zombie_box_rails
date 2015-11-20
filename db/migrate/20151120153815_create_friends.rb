class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
    	t.integer :user_id
    	t.boolean :is_pending
    	t.date :friend_date

    	t.integer :friendable_id
    	t.string :friendable_type

      t.timestamps
    end

    add_index :friends, :user_id
    add_index :friends, :friendable_id
    add_index :friends, :friendable_type
  end
end
