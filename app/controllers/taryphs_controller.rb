class TaryphsController < ApplicationController
  before_action :set_taryph, only: [:show, :edit, :update, :destroy]

  # GET /taryphs
  # GET /taryphs.json
  def index
    @price = Price.find(params[:price_id])
    @taryphs = @price.taryph.all

  end

  # GET /taryphs/1
  # GET /taryphs/1.json
  def show
  end

  # GET /taryphs/new
  def new
    @price = Price.find(params[:price_id])
    @rooms = Room.find(@price.room_id)
    @hotel = Hotel.find(@rooms.hotel_id)
    @taryph = @price.taryph.build

  end

  # GET /taryphs/1/edit
  def edit
    @taryph = Taryph.find(params[:id])
    @price = Price.find(@taryph.price_id)
    @rooms_ = Room.find(@price.room_id)
    @hotel_ = Hotel.find(@rooms_.hotel_id)
    @udate_ = @taryph.udate
    @edate_ = @taryph.edate
    @index_ = @taryph.index
  end

  # POST /taryphs
  # POST /taryphs.json
  def create
    @price = Price.find(params[:price_id])
    @rooms = Room.find(@price.room_id)
    @hotel = Hotel.find(@rooms.hotel_id)
    @taryph = @price.taryph.build(taryph_params)

    respond_to do |format|
      if @taryph.save
        format.html { redirect_to price_taryphs_url, notice: 'Taryph was successfully created.' }
        format.json { render :show, status: :created, location: @taryph }
      else
        format.html { render :new }
        format.json { render json: price_taryphs_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /taryphs/1
  # PATCH/PUT /taryphs/1.json
  def update
    @taryph = Taryph.find(params[:id])
    @price = @taryph.price
    @rooms = Room.find(@price.room_id)
    @hotel = Hotel.find(@rooms.hotel_id)
    respond_to do |format|
      if @taryph.update(taryph_params)
        format.html { redirect_to price_taryphs_url(@price.id), notice: 'Taryph was successfully updated.' }
        format.json { render :show, status: :ok, location: ([@price,@taryph]) }
      else
        format.html { render :edit }
        format.json { render json: ([@price,@taryph]).errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taryphs/1
  # DELETE /taryphs/1.json
  def destroy
    @taryph = Taryph.find(params[:id])
    @price = @taryph.price
    @taryph.destroy
    respond_to do |format|
      format.html { redirect_to price_taryphs_url(@price.id), notice: 'Taryph was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_taryph
      @taryph = Taryph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def taryph_params
      params.permit(:price_id, :id, :udate, :edate, :index)
    end
end
