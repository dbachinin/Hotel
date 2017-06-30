class Booking < ApplicationRecord
	# belongs_to :ad_service
	belongs_to :user


	def search_employ
		@lock = []
		Booking.all.each {|i| @lock.push(i.id) if (Date.parse(self.check_in.to_s) - Date.parse(i.check_out.to_s)) * (Date.parse(i.check_in.to_s) - Date.parse(self.check_out.to_s)) >= 0 && i.room_id == self.room_id } 
		return @lock

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

	end
