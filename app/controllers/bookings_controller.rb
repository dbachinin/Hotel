class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  #respond_to :pdf
  # require 'app/pdfs/BookingReports'
  include SubtotalHelper
  include FullemployHelper
  # GET /bookings
  # GET /bookings.json
  def index
    if current_user.id == 1
      @bookings = Booking.all
      @date = params[:date] ? Date.parse(params[:date]) : Date.today

      @dd = employ_rooms
      # @buk = [] 
      # Booking.all.each{|e| @buk << e.id if (Date.parse(e.check_in.to_s)..Date.parse(e.check_in.to_s)).include?(@date.at_beginning_of_month)or(Date.parse(e.check_in.to_s)..Date.parse(e.check_in.to_s)).include?(@date.at_end_of_month)or(@date.at_beginning_of_month..@date.at_end_of_month).include?(Date.parse(e.check_in.to_s)..Date.parse(e.check_in.to_s))}
      # @bukhash = {}
      # Booking.find(@buk).each{|i| @bukhash[i.id] = ((i.check_in.to_s) + ',' + (i.check_out.to_s)) }
      # @bukhash.each do |k,v| 
      # hot = Room.find(Booking.find(k).room_id).name + " в " + Hotel.find(Booking.find(k).hotel_id).name 
      # p hot if (Date.parse(v.split(',').first)..Date.parse(v.split(',').last)).include?(Date.parse(d.to_s))

      # end

    else
      @bookings = current_user.bookings.all
    end
    #@hotel = Hotel.find(params[:hotel_id])
    #@room = Room.find(params[:room_id])
  end
  def subprice

    @subprice = price_subtotal(params[:room_id],Date.parse(params[:check_in]),Date.parse(params[:check_out]).to_s) + params[:ad_service].inject(0){|sum, x| sum + Service.find(x).price} if params[:ad_service] != ""
    @subprice = price_subtotal(params[:room_id],Date.parse(params[:check_in]),Date.parse(params[:check_out]).to_s) if params[:ad_service] == ""
    # @date = params[:date] ? Date.parse(params[:date]) : Date.today
    # @statuses = []

    # p params[:ad_service]    
    # p @subprice
  end
  # GET /bookings/1
  # GET /bookings/1.json
  def show
    @room_id = @booking.room_id
    @booking.ad_service.reject! { |c| c.empty? }

  end

  def download_pdf
    define_params = params
    @booking = (define_params[:booking])
    pdf = BookingReports.new(request.original_url,@booking).to_pdf
    send_data pdf, :type => 'application/pdf', :filename => "performe_#{@booking}.pdf"
  end

  # GET /bookings/new
  def new
    @booking = current_user.bookings.build
    @hotel = Hotel.find(params[:hotel_id])
    @room = Room.find(params[:room_id])
    @disa = employ_rooms(@room.id,@booking.check_in, @booking.check_out)
    @disa.uniq!
    @booking.discount = current_user.discount

     # respond_to do |format|
      # format.html
       # format.json
    #   format.js
     # end
     p @disa 
   # @room.price.last.taryph.each {|i| p "fff" if Date.parse(i.udate.to_s) < Date.parse('2017-04-18') and Date.parse(i.edate.to_s) < Date.parse('2017-04-18')}
 end

  # GET /bookings/1/edit
  def edit
    @room = @booking.room_id

    # @subprice = price_subtotal(@booking.room_id,Date.parse(@booking.check_in).to_s,Date.parse(@booking.check_out).to_s)
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = current_user.bookings.build(booking_params)
    @hotel = Hotel.find(@booking.hotel_id)
    @room = Room.find(@booking.room_id)
    @booking.ad_service.reject! { |c| c.empty? }
    @booking.subtotal = price_subtotal(@booking.room_id,@booking.check_in,@booking.check_out) + @booking.ad_service.inject(0){|sum, x| sum + Service.find(x).price} if @booking.ad_service != ""
    @booking.subtotal = price_subtotal(@booking.room_id,@booking.check_in,@booking.check_out) if @booking.ad_service == ""
    @booking.discount = current_user.discount
    if @booking.save
      respond_to do |format|
        format.html { redirect_to @booking, notice: (t 'bcreate') }
        format.json { render :show, status: :created, location: @booking }
      end
    else
      respond_to do |format|
        format.html { render :new, locals: {hotel_id: @hotel.id, room_id: @room.id} }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    @booking.ad_service.reject! { |c| c.empty? }
    @booking.subtotal = price_subtotal(@booking.room_id,@booking.check_in,@booking.check_out) + @booking.ad_service.inject(0){|sum, x| sum + Service.find(x).price} if @booking.ad_service != ""
    @booking.subtotal = price_subtotal(@booking.room_id,@booking.check_in,@booking.check_out) if @booking.ad_service == ""
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: (t 'bupdate') }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: (t 'bdelete') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:check_in, :check_out, :hotel_id, :room_id, :booked, :subtotal, :discount, :ad_service => [])
    end
  end
