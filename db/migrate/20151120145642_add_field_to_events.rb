class AddFieldToEvents < ActiveRecord::Migration
  def change
  	add_column :events ,:start_date, :date
  	add_column :events, :end_date, :date

  	remove_column :events, :date
  end
end
