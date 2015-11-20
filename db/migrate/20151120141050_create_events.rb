class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.string :name
    	t.integer :event_type_id
    	t.text :description
    	t.time :start_time
    	t.time :end_time
    	t.date :date

    	t.timestamps
    end

    create_table :event_types do |t|
    	t.string :name

    	t.timestamps
    end

    add_index :events, :event_type_id
  end
end