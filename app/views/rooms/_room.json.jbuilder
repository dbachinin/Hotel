json.extract! room, :id, :name, :description, :bad, :lux, :created_at, :updated_at
json.url room_url(room, format: :json)
