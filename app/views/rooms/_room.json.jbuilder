json.extract! room, :id, :name, :description, :bed, :lux, :created_at, :updated_at
json.url hotel_room_url(room, format: :json)
