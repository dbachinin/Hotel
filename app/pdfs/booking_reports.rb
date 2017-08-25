class BookingReports < Prawn::Document
  include SubtotalHelper
  def initialize(url, booking)
    super()
    @url, @booking = url, Booking.find(booking)
    @booking.ad_service.reject! { |c| c.empty? }
  end


  require 'rqrcode'

  def to_pdf
    font_families.update(
      "Helvetica" => {
        :bold => "#{Rails.root}/app/fonts/Helvetica Neue Condensed Bold.ttf",
        :normal  => "#{Rails.root}/app/fonts/Helvetica Neue Condensed Black.ttf" },
        "OpenSans" => {
          :normal => "#{Rails.root}/app/fonts/2211.ttf",
          :light => "#{Rails.root}/app/fonts/2209.ttf"
          })
    qr = RQRCode::QRCode.new(@url)
    code = qr.as_png(
          resize_gte_to: false,
          resize_exactly_to: false,
          fill: 'white',
          color: 'black',
          size: 120,
          border_modules: 4,
          module_px_size: 6,
          file: "tmp/#{@booking.id}.png"
          )
    image "#{Rails.root}/app/assets/images/logo.png", position: 150, width: 200

IO.write("#{Rails.root}/tmp/#{@booking.id}.png", code.to_s.force_encoding("UTF-8"))
    image "#{Rails.root}/tmp/#{@booking.id}.png", vposition: 10
        vertical_line 0,0, at: 100
    font "Helvetica", :size => 10
    text ((I18n.t :accomod) + ": " + (Hotel.find(@booking.hotel_id).name)).to_s.upcase, :size => 15, :style => :bold, :align => :center
    move_down(5)
    font "OpenSans", :size => 10, :style => :light
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
    move_down(10)
    text (I18n.t :adservices), :size => 15, :style => :normal, :align => :center
    move_down(10)

    Service.find(@booking.ad_service).each do |service| 
     text (I18n.t :adservice) + ":"
     text (service.name) + ":" + (service.price.to_s) + " Руб",  :align => :left, :style => :normal, :size => 9
   end
    text (I18n.t :discount) + ':'
    text (@booking.discount != nil ? @booking.discount : 0).to_s + '%'
    move_down(10)
   stroke_horizontal_rule
   move_down(10)
   text (I18n.t :total) + ":"
   text @booking.subtotal.to_s + " Руб"

   creation_date = Time.zone.now.strftime("Счет сгенерирован %e %b %Y в %H:%M")
   go_to_page(page_count)
   move_down(700)
   text creation_date, :align => :right, :style => :normal, :size => 9
   render
 end





end