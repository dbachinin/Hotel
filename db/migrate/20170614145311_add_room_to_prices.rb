class AddRoomToPrices < ActiveRecord::Migration[5.1]
  def change
    add_reference :prices, :room, foreign_key: true
  end
end
