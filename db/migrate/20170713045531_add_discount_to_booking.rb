class AddDiscountToBooking < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :discount, :references
  end
end
