class Booking < ApplicationRecord
	has_many :services, dependent: :destroy
	belongs_to :user
	with_options if: :employ?, on: :create do |room| 
		room.validates :check_in, presence: true, if: :employed_room
		room.validates :check_out, presence: true, if: :employed_room
	end
	validates_exclusion_of :subtotal, { in: [0.0] }
	before_save :add_discount
	# def search_employ
	# 	@lock = []
	# 	Booking.all.each {|i| @lock.push(i.id) if (Date.parse(self.check_in.to_s) - Date.parse(i.check_out.to_s)) * (Date.parse(i.check_in.to_s) - Date.parse(self.check_out.to_s)) >= 0 && i.room_id == self.room_id } 
	# 	return @lock

	# end

	def add_discount
		if self.discount
			self.subtotal = self.subtotal / 100 * self.discount
		end
	end

	def search_full_employ(room_id)
		@found = []
		Booking.where(room_id: room_id).each do |i|
			b = Booking.where(id: i).first; (Date.parse(b.check_in.to_s)..Date.parse(b.check_out.to_s)).each {|d| @found.push(d.strftime) }
			# b = Booking.where(id: i).first; (Date.parse(b.check_in.to_s)..Date.parse(b.check_out.to_s)).each {|d| @found.push(d.strftime '%Q') }
		end
		return @found
	end
		# price = Price.find(tar.find(@tar).price_id)
		# cen = price + Taryph.find(@tar).index if (check_in - Taryph.find(@tar).edate).to_i > (check_in - check_out).to_i
		
		private
		def employed_room
			Booking.where(room_id: self.room_id).each do |i|
				if Date.parse(i.check_out.to_s) <= Date.parse(self.check_out.to_s) && Date.parse(i.check_in.to_s) >= Date.parse(self.check_in.to_s)
					errors.add(:check_in, "error date")

				end
			end
		end
	end
