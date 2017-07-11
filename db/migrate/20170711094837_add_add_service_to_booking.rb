class AddAddServiceToBooking < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :ad_service, :text, default: [], array:true
  end
end
