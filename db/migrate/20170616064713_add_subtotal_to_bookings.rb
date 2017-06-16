class AddSubtotalToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :subtotal, :float
  end
end
