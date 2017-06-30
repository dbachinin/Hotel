class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  include SubtotalHelper
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = current_user.bookings.all
    #@hotel = Hotel.find(params[:hotel_id])
    #@room = Room.find(params[:room_id])
  end
  def subprice
    @dat = price_subtotal(params[:room_id],params[:check_in],params[:check_out])
  end
  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = current_user.bookings.build
    @hotel = Hotel.find(params[:hotel_id])
    @room = Room.find(params[:room_id])
    @disa = @booking.search_full_employ(@room.id)
    @disa.uniq!
    # p @disa 
   # @room.price.last.taryph.each {|i| p "fff" if Date.parse(i.udate.to_s) < Date.parse('2017-04-18') and Date.parse(i.edate.to_s) < Date.parse('2017-04-18')}
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = current_user.bookings.build(booking_params)
    @booking.subtotal = price_subtotal(@booking.room_id,@booking.check_in,@booking.check_out)
    if @booking.save
      respond_to do |format|
        format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
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
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
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
      params.require(:booking).permit(:check_in, :check_out, :hotel_id, :room_id, :booked, :subtotal)
    end
end
