class AddBookingToService < ActiveRecord::Migration[5.1]
  def change
    add_reference :services, :booking, foreign_key: true
  end
end
