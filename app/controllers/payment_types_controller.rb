class PaymentTypesController < ApplicationController
  before_action :set_payment_type, only: [:show, :edit, :update]
  before_action :set_payment_types, only: [:destroy]

  # GET /payment_types
  # GET /payment_types.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: PaymentTypeDatatable.new(view_context) }
    end
  end

  # GET /payment_types/1
  # GET /payment_types/1.json
  def show
  end

  # GET /payment_types/new
  def new
    @payment_type = PaymentType.new
  end

  # GET /payment_types/1/edit
  def edit
  end

  # POST /payment_types
  # POST /payment_types.json
  def create
    @payment_type = PaymentType.new(payment_type_params)

    respond_to do |format|
      if @payment_type.save
        format.any { redirect_to payment_types_path, notice: 'Payment type was successfully created.' }
      else
        format.html { render :new }
        format.json
      end
    end
  end

  # PATCH/PUT /payment_types/1
  # PATCH/PUT /payment_types/1.json
  def update
    respond_to do |format|
      if @payment_type.update(payment_type_params)
        format.html { redirect_to @payment_type, notice: 'Payment type was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_type }
      else
        format.html { render :edit }
        format.json
      end
    end
  end

  # DELETE /payment_types/1
  # DELETE /payment_types/1.json
  def destroy
    @payment_types.map(&:destroy)
    respond_to do |format|
      format.html { redirect_to payment_types_path, notice: 'Payment type was successfully destroyed.' }
      format.json { render json: { data: [] } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_type
      @payment_type = PaymentType.find(params[:id])
    end

    def set_payment_types
      @payment_types = PaymentType.find(params[:id].split(','))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_type_params
      params.require(:payment_type).permit(:name, :description)
    end
end
