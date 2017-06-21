class AdServicesController < ApplicationController
  before_action :set_ad_service, only: [:show, :edit, :update, :destroy]

  # GET /ad_services
  # GET /ad_services.json
  def index
    @ad_services = AdService.all
  end

  # GET /ad_services/1
  # GET /ad_services/1.json
  def show
  end

  # GET /ad_services/new
  def new
    @ad_service = AdService.new
  end

  # GET /ad_services/1/edit
  def edit
  end

  # POST /ad_services
  # POST /ad_services.json
  def create
    @ad_service = AdService.new(ad_service_params)

    respond_to do |format|
      if @ad_service.save
        format.html { redirect_to @ad_service, notice: 'Ad service was successfully created.' }
        format.json { render :show, status: :created, location: @ad_service }
      else
        format.html { render :new }
        format.json { render json: @ad_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ad_services/1
  # PATCH/PUT /ad_services/1.json
  def update
    respond_to do |format|
      if @ad_service.update(ad_service_params)
        format.html { redirect_to @ad_service, notice: 'Ad service was successfully updated.' }
        format.json { render :show, status: :ok, location: @ad_service }
      else
        format.html { render :edit }
        format.json { render json: @ad_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ad_services/1
  # DELETE /ad_services/1.json
  def destroy
    @ad_service.destroy
    respond_to do |format|
      format.html { redirect_to ad_services_url, notice: 'Ad service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ad_service
      @ad_service = AdService.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ad_service_params
      params.require(:ad_service).permit(:name, :price, :enable)
    end
end
