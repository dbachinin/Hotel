json.extract! booking, :id, :check_in, :check_out, :hotel_id, :room_id, :booked, :created_at, :updated_at, :subprice
json.url booking_url(booking, format: :json)
