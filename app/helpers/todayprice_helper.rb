module TodaypriceHelper
	def price_today(today, room_id)
		TodayPrice.new(today, room_id).select_price
	end

	class TodayPrice
		def initialize(today, room_id)
			@today, @room_id = today, room_id
		end

		attr_accessor :today, :room_id

		def select_price
			Room.find(room_id).price.taryph.each {|i| @tprice = Price.find(i.price_id).price + i.index if (i.udate...i.edate).include?(today)}
			return @tprice
		end
		
	end
end

