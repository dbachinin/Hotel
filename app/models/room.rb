class Room < ApplicationRecord
	belongs_to :hotel
	has_one :price, as: :room
	def image_urls
		@files = []
		dir = 'room' + self.id.to_s+'/'
		Dir.foreach('app/assets/images/'+dir) do |item|
			@files.push(dir+item.to_s) if item.include? "jpg"
		end
		return @files
		# ["car/1.jpg","car1/2.jpg","car1/3.jpg"]
	end
end
