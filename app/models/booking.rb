class Booking < ApplicationRecord
	# belongs_to :ad_service
	def calc_subtotal
		# days_count = (self.check_in - self.check_out).to_i

		tar = Room.find(self.room_id).price.last.taryph
		@cena ||=0
		zaezd = Date.parse(self.check_in.to_s)
		otezd = Date.parse(self.check_out.to_s)

		@tar = []; tar.each do |i| 
			nachalo_perioda =	Date.parse(i.udate.to_s)
			conec_perioda   = 	Date.parse(i.edate.to_s)
			@tar.push(i.id) 	if zaezd >= nachalo_perioda and zaezd < conec_perioda
			@tar.push(i.id) 	if nachalo_perioda > zaezd 	and nachalo_perioda < otezd
		end
		if @tar == []
			then
			self.subtotal = Room.find(self.room_id).price.last.price * (otezd - zaezd).to_i
			self.save
		else
			@tar.each do |i|
				cena = Room.find(self.room_id).price.last.price + tar.find(i).index
				nachalo_perioda = Date.parse(tar.find(i).udate.to_s)
				conec_perioda = Date.parse(tar.find(i).edate.to_s)

			#Calculate days count for end of start price period
			
			length_period = (conec_perioda - zaezd).to_i           if zaezd >= nachalo_perioda and otezd >= conec_perioda#; p "ppp #{length_period}"
			length_period = (conec_perioda - nachalo_perioda).to_i if zaezd <= nachalo_perioda and otezd >= conec_perioda#; p "fff #{length_period}"
			length_period = (otezd - nachalo_perioda).to_i         if zaezd <= nachalo_perioda and otezd <= conec_perioda#; p "aaa #{length_period}"
			length_period = (otezd - zaezd).to_i                   if zaezd >= nachalo_perioda and otezd <= conec_perioda#; p "ggg #{length_period}"
			@cena = @cena + (cena * length_period.to_f)

			self.subtotal = @cena
			self.save
		end
			#puts @cena 
			#puts @tar 
		end
	end

	def search_employ
		@lock = []
		Booking.all.each {|i| @lock.push(i.id) if (Date.parse(self.check_in.to_s) - Date.parse(i.check_out.to_s)) * (Date.parse(i.check_in.to_s) - Date.parse(self.check_out.to_s)) >= 0 && i.room_id == self.room_id } 
		return @lock

	end

	def search_full_employ(room_id)

		@found = []
		Booking.where(room_id: room_id).each do |i|
			b = Booking.where(id: i).first; (Date.parse(b.check_in.to_s)..Date.parse(b.check_out.to_s)).each {|d| @found.push(d.strftime) }
		end
		return @found
	end
		# price = Price.find(tar.find(@tar).price_id)
		# cen = price + Taryph.find(@tar).index if (check_in - Taryph.find(@tar).edate).to_i > (check_in - check_out).to_i

	end
