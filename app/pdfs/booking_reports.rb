class BookingReports < Prawn::Document
  include SubtotalHelper
  def initialize(booking)
  super()
  @booking = Booking.find(booking)
end



  def to_pdf
    font_families.update(
      "Helvetica" => {
        :bold => "#{Rails.root}/app/fonts/Helvetica Neue Condensed Bold.ttf",
        :normal  => "#{Rails.root}/app/fonts/Helvetica Neue Condensed Black.ttf" })
    font "Helvetica", :size => 10
    text ((I18n.t :accomod) + ": " + (Hotel.find(@booking.hotel_id).name)).to_s.upcase, :size => 15, :style => :bold, :align => :center
    move_down(5)
    text "Счет на бронирование за #{I18n.l Date.parse(@booking.created_at.to_s), format: :short}"
    move_down(18)
    text (I18n.t :client) + ':', :align => :left, :style => :normal, :size => 9
    text User.find(@booking.user_id).firstname + " " + User.find(@booking.user_id).lastname,  :align => :left, :style => :normal, :size => 9
    move_down(5)
    text (I18n.t :check_in) + ':'
    text I18n.l Date.parse(@booking.check_in.to_s), format: :short
    move_down(5)
    text (I18n.t :check_out) + ':'
    text I18n.l Date.parse(@booking.check_out.to_s), format: :short
    move_down(5)
    text (I18n.t :hotel) + ':'
    text Hotel.find(@booking.hotel_id).name
    move_down(5)
    text (I18n.t :room) + ':'
    text Room.find(@booking.room_id).name
    move_down(5)
    text (I18n.t :subtotall) + ':'
    text price_subtotal(@booking.room_id,@booking.check_in,@booking.check_out).to_s
    stroke_horizontal_rule
    pad(20) { }
    

    creation_date = Time.zone.now.strftime("Отчет сгенерирован %e %b %Y в %H:%M")
    go_to_page(page_count)
    move_down(710)
    text creation_date, :align => :right, :style => :normal, :size => 9
    render
  end
  




end