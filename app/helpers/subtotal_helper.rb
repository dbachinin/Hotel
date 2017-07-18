module SubtotalHelper
	def price_subtotal(room_id,check_in,check_out)
		Subtotal.new(room_id,check_in, check_out).calc_subtotal
	end

	class Subtotal
		def initialize(room_id,check_in,check_out)
			@room_id, @check_in, @check_out = room_id, check_in, check_out
		end

		attr_accessor :room_id, :check_in, :check_out

		def calc_subtotal
			tar = Room.find(room_id).price.taryph
			@cena ||=0
			zaezd = Date.parse(check_in.to_s)
			otezd = Date.parse(check_out.to_s)

			@tar = []; tar.each do |i| 
				nachalo_perioda =	Date.parse(i.udate.to_s)
				conec_perioda   = 	Date.parse(i.edate.to_s)
				@tar.push(i.id) 	if zaezd >= nachalo_perioda and zaezd < conec_perioda
				@tar.push(i.id) 	if nachalo_perioda > zaezd 	and nachalo_perioda < otezd
			end
			# p @tar

			@tar.each do |i|
				cena = Room.find(room_id).price.price + Taryph.find(i).index
				nachalo_perioda = Date.parse(tar.find(i).udate.to_s)
				conec_perioda = Date.parse(tar.find(i).edate.to_s)

			#Calculate days count for end of start price period
			# p cena, i
			length_period = (conec_perioda - zaezd).to_i           if zaezd >= nachalo_perioda and otezd >= conec_perioda#; p "ppp #{length_period}"
			length_period = (conec_perioda - nachalo_perioda).to_i if zaezd <= nachalo_perioda and otezd >= conec_perioda#; p "fff #{length_period}"
			length_period = (otezd - nachalo_perioda).to_i         if zaezd <= nachalo_perioda and otezd <= conec_perioda#; p "aaa #{length_period}"
			length_period = (otezd - zaezd).to_i                   if zaezd >= nachalo_perioda and otezd <= conec_perioda#; p "ggg #{length_period}"
			@cena = @cena + (cena * length_period.to_f)
			
		



	end
	return @cena
end
end
end