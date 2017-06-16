class AddHotelIdToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :hotel_id, :integer
  end
end
