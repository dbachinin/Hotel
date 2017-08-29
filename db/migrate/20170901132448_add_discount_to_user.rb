class AddDiscountToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discount, :integer, default: 0 
  end
end
