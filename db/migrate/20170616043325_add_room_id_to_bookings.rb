class AddRoomIdToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :room_id, :integer
  end
end
