class AddFieldToEventTypes < ActiveRecord::Migration
  def change
  	add_column :event_types, :description, :text
  end
end
