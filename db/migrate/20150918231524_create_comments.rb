class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

    	t.integer :user_id
    	t.timestamp :post_date
    	t.text :text
    	t.boolean :approved, :default => false

    	t.integer :commentable_id
    	t.string :commentable_type

      t.timestamps null: false
    end

    add_index :comments, :user_id
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
  end
end