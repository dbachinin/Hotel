class AddAdServiceToBooking < ActiveRecord::Migration[5.1]
  def change
    add_reference :bookings, :ad_services, foreign_key: true
  end
end
