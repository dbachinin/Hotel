module FullemployHelper

		def employ_rooms
		@found = []
		Booking.all.each do |i|
			b = Booking.where(id: i).first; (Date.parse(b.check_in.to_s)..Date.parse(b.check_out.to_s)).each {|d| @found.push(Date.parse(d.strftime)) }
			# b = Booking.where(id: i).first; (Date.parse(b.check_in.to_s)..Date.parse(b.check_out.to_s)).each {|d| @found.push(d.strftime '%Q') }
		end
		return @found
		end

end

