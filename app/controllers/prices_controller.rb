class PricesController < ApplicationController
  before_action :set_price, only: [:show, :edit, :update, :destroy]

  # GET /prices
  # GET /prices.json
  def index
    @hotel = Hotel.find(params[:hotel_id])
    @rooms = @hotel.rooms.find(params[:room_id])
    @prices = @rooms.price.all
  end

  # GET /prices/1
  # GET /prices/1.json
  def show
    # @hotel = Hotel.find(params[:hotel_id])
    # @rooms = @hotel.rooms.find(params[:room_id])
    @price = Price.find(params[:id])
    @rooms_ = Room.find(@price.room_id)
    @hotel_ = Hotel.find(@rooms_.hotel_id)
  end

  # GET /prices/new
  def new
    @hotel = Hotel.find(params[:hotel_id])
    @rooms = @hotel.rooms.find(params[:room_id])
    @price = @rooms.price.build
    @hotel_id = params[:hotel_id]
  end

  # GET /prices/1/edit
  def edit
    @price = Price.find(params[:id])
    @rooms_ = Room.find(@price.room_id)
    @hotel_ = Hotel.find(@rooms_.hotel_id)
    @price_val = @price.price
    @desc_val = @price.description
  end

  # def testing
    
  #   @hotel = Hotel.find(@hotel_id)
    
  #   @rooms = @hotel.rooms.find(params[:room_id])
  #   @price = @rooms.price.build
  # end

  # POST /prices
  # POST /prices.json
  def create
    p @hotel_id
    @hotel = Hotel.find(params[:hotel_id])
    @rooms = @hotel.rooms.find(params[:room_id])
    @price = @rooms.price.build(price_params)
    
    respond_to do |format|
      if @price.save
        format.html { redirect_to hotel_room_prices_path, notice: 'Price was successfully created.' }
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prices/1
  # PATCH/PUT /prices/1.json
  def update
    @price = Price.find(params[:id])
    @rooms = Room.find(@price.room_id)
    @hotel = Hotel.find(@rooms.hotel_id)
    respond_to do |format|
      if @price.update(price_params)
        format.html { redirect_to @price, notice: 'Price was successfully updated.' }
        format.json { render :show, status: :ok, location: @price }
      else
        format.html { render :edit }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prices/1
  # DELETE /prices/1.json
  def destroy
    @price = Price.find(params[:id])
    @rooms = Room.find(@price.room_id)
    @hotel = Hotel.find(@rooms.hotel_id)
    @price.destroy
    respond_to do |format|
      format.html { redirect_to ([@hotel,@rooms,@price]), notice: 'Price was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price
      @price = Price.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_params
      params.permit(:price, :description)
    end
end
