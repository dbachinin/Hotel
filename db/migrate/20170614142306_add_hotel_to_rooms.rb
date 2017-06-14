class AddHotelToRooms < ActiveRecord::Migration[5.1]
  def change
    add_reference :rooms, :hotel, foreign_key: true
  end
end
