class AddDiscountToBooking < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :discount, :integer
  end
end
