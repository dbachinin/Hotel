class AddBookedToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :booked, :boolean
  end
end
