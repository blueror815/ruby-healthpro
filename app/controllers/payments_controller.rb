class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update]
  before_action :set_payments, only: [:destroy]

  # GET /payments
  # GET /payments.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: PaymentDatatable.new(view_context) }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @view_location = params[:view_location] || nil
    hash_param = {}
    if params[:bill_id]
      bill = Bill.find(params[:bill_id]) 
      hash_param[:bill_id] = bill.id
      hash_param[:patient_id] = bill.patient_id
      hash_param[:claim_type_id] = bill.claim_type_id
    end
    @payment = Payment.new(hash_param)
    set_html_elements
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @view_location = params[:view_location] || nil
    @payment = Payment.new(payment_params)
    @bill = Bill.find(@payment.bill.id)
    @payment.claim_type_id = @bill.claim_type_id
    @payment.patient_id = @bill.patient_id
    @payment.insurance_company_id = @bill.insurance_company_id

    respond_to do |format|
      if @payment.save
        format.html { redirect_to payments_url, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
        format.js
      else
        format.html { render :new }
        format.json
        format.js
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to payments_path, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
        format.js
      else
        format.html { render :edit }
        format.json
        format.js
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payments.map(&:destroy)
    respond_to do |format|
      format.html { redirect_to payments_path, notice: 'Payment was successfully destroyed.' }
      format.json { render json: { data: [] } }
    end
  end

  private
   def set_html_elements
      @instance = @payment
      @model = "payment"
      # TODO_PROHEALTH this needs to be refactors can't use count 
      @id = Payment.count
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    def set_payments
      @payments = Payment.find(params[:id].split(','))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params[:payment][:bill_id] = params[:bill_id] if params[:bill_id]
      params.require(:payment).permit(:date, :amount, :notes, :payment_type_id,
                                      :patient_id, :claim_type_id,
                                      :payment_type_id, :insurance_company_id, :bill_id)
    end
end
