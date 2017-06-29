class Room < ApplicationRecord
	belongs_to :hotel
	has_many :price
	def image_urls
		["car1/1.jpg","car1/2.jpg","car1/3.jpg"]
	end
end
