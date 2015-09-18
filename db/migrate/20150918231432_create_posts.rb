class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

    	t.integer :user_id
    	t.text :name
    	t.timestamp :post_date
    	t.text :text

      t.timestamps null: false
    end

    add_index :posts, :user_id

  end
end

