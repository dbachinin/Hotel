class AddCountToRoom < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :count, :integer
  end
end
