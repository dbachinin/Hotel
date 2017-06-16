class Booking < ApplicationRecord
	def calc_subtotal(room)
		days_count = (self.check_in - self.check_out).to_i
		tar = room.price.last.taryph
		@cen = []
		@tar = []; tar.each {|i| @tar.push(i.id) if self.check_in > i.udate and i.edate > self.check_in or i.udate == self.check_in }
		@tar.each do |i|
			cen = @room.price.last.price + tar.find(i).index; p cen
			temp = (check_in - tar.find(i).edate).to_i.abs
			@cen.push(temp) if Date.parse(check_in.to_s) > Date.parse(tar.find(i).udate.to_s) and Date.parse(check_out.to_s) > Date.parse(tar.find(i).edate.to_s); temp = nil
			temp = (tar.find(i).udate - tar.find(i).edate).to_i.abs
			@cen.push(temp) if Date.parse(check_in.to_s) < Date.parse(tar.find(i).udate.to_s) and Date.parse(check_out.to_s) > Date.parse(tar.find(i).edate.to_s); temp = nil
			temp = (tar.find(i).edate - check_out).to_i.abs
			@cen.push(temp) if Date.parse(check_out.to_s) > Date.parse(tar.find(i).edate.to_s); temp = nil
			temp = (check_in - check_out).to_i.abs
			@cen.push(temp) if Date.parse(check_out.to_s) < Date.parse(tar.find(i).edate.to_s) and Date.parse(check_in.to_s) < Date.parse(tar.find(i).udate.to_s); temp = nil

		end


		
		# price = Price.find(tar.find(@tar).price_id)
		# cen = price + Taryph.find(@tar).index if (check_in - Taryph.find(@tar).edate).to_i > (check_in - check_out).to_i

end
