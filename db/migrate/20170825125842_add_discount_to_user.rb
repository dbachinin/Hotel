class AddDiscountToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discount, :integer
  end
end
