class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :update]
  before_action :set_bills, only: [:destroy]
  before_action :set_date_interval_params, only: [:receivables, :reports]
  before_action :check_if_upload_inprogress, only: [:index]

  # GET /bills
  # GET /bills.json
  def index
    authorize! :view, Bill
    @bill = Bill.new
    @bills = Bill.includes(:patient, :claim_type, :insurance_company).order(:date)
    from = params[:from].try(:strftime, "%d_%m_%Y")
    to = params[:to].try(:strftime, "%d_%m_%Y")
    date_range_name = (from &&  to) ? "#{from}_#{to}" : 'All'
    filename = "bills_#{date_range_name}.xls"
    respond_to do |format|
      format.html
      format.js
      format.json { render json: BillDatatable.new(view_context) }
      format.xls { send_data(Bill.to_csv(@bills), filename: filename) }
    end
  end

  def index_report_bills
    respond_to do |format|
      format.html
      format.json { render json: ReportBillDatatable.new(view_context) }
    end
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
    authorize! :view, Bill
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills
  # POST /bills.json
  def create
    authorize! :edit, Bill
    @bill = Bill.new(bill_params)
    respond_to do |format|
      if @bill.save
        format.html { redirect_to bills_path, notice: 'Bill was successfully created.' }
        format.json { render :show, status: :created, location: @bill }
        format.js { @bill = Bill.new }
      else
        format.html { render :new }
        format.json
        format.js
      end
    end
  end

  # PATCH/PUT /bills/1
  # PATCH/PUT /bills/1.json
  def update
    authorize! :edit, Bill
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to bills_path, notice: 'Bill was successfully updated.' }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :edit }
        format.json
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    authorize! :edit, Bill
    @bills.map(&:destroy)
    respond_to do |format|
      format.html { redirect_to bills_path, notice: 'Bill was successfully destroyed.' }
      format.json { render json: { data: [] } }
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def delete_all_bills
    authorize! :edit, Bill
    Bill.delete_all
    Payment.delete_all
    redirect_to bills_path
  end

  def fetch_bill_paid_amount
    @bill = Bill.find(params[:bill_id])  
  end

  def receivables
    authorize! :view, Bill

    @summary_filter_keys = if params[:filter_type] === "Claim" then [:claim_type, :insurance] else [:insurance, :claim_type] end

    respond_to do |format|
      format.xls do
        set_revceivables
        from = params[:from].try(:strftime, "%d_%m_%Y")
        to = params[:to].try(:strftime, "%d_%m_%Y")
        date_range_name = (from &&  to) ? "#{from}_#{to}" : 'All'
        report_type_name = if !params['export_summary']
          'recievables_insights'
        elsif params['export_summary'] == 'true'
          'recievables_summary'
        else
          'recievables'
        end
        filename = "#{report_type_name}_#{date_range_name}.xls"

        send_data(Bill.receivables_csv(@bills, params, @summary_filter_keys), filename: filename)
      end
      format.html { set_revceivables }
      format.json { render json: ReceivablesDatatable.new(view_context) }
    end
  end

  def import
    bills_file = "public/bills_#{DateTime.now.to_s}#{File.extname(params[:file].path)}" if params[:file]
    File.open(bills_file, "wb") { |f| f.write(params[:file].read) } if params[:file]
    puts ">>>>>>>>>>>>> file uploaded!"
    Bill.delay.import(bills_file)
    @uploading = true
    redirect_to bills_path, notice: "Bills are being imported."
  end

  def reports
    authorize! :view, Bill
    @bills_summary = {}
    @queried_bills = fetch_bills_in_range([:claim_type, :insurance_company, :patient])
    @summary_filter_keys = if params[:filter_type] === "Claim" then [:claim_type, :insurance] else [:insurance, :claim_type] end
    @bills = build_bills_reports(@queried_bills)

    respond_to do |format|
      bills_report_respond_to(format, @queried_bills, @bills, @bills_summary)
    end
  end

  def payments
    authorize! :view, Bill
    @payments = Payment.all.group_by{|s| [s.bill.claim_type.name, s.bill.insurance_company.name]}.map{|k, v| [k.first, k.last, v.map(&:amount).reduce(:+)]}
  end

  private
    def check_if_upload_inprogress
      active_jobs = Delayed::Job.where(failed_at: nil)
      active_jobs.each do |job|
        handler = job.handler
        class_name = handler.split("\n")[1].try(:split, "!ruby/class").try(:last)
        class_name = class_name.strip.gsub(/\s|"|'/, '') if class_name
        action = handler.split("\n")[2].try(:split, ":").try(:last)
        if class_name == 'Bill' && action == 'import'
          @uploading = true
          flash[:notice] = "Bills are being imported." if params[:action] = 'index'
        end
      end
    end

    def bills_report_respond_to(format, queried_bills, bills, bills_summary)
      format.html
      format.xls do 
        from = params[:from].try(:strftime, "%d_%m_%Y")
        to = params[:to].try(:strftime, "%d_%m_%Y")
        date_range_name = (from &&  to) ? "#{from}_#{to}" : 'All'
        report_type_name = if !params['export_summary']
          'bills_insights'
        elsif params['export_summary'] == 'true'
          'bills_summary'
        else
          'bills'
        end
        filename = "#{report_type_name}_#{date_range_name}.xls"
        send_data(Bill.reports_csv(queried_bills, bills, bills_summary, params, @summary_filter_keys), filename: filename) 
      end       
    end

    def fetch_bills_in_range(includes_list)
      Bill.includes(includes_list).range(params[:from], params[:to]).order(date: :desc)
    end

    def build_bills_reports(queried_bills)
      filter_key = @summary_filter_keys.first
      queried_bills.group_by{|s| [s.claim_type.try(:name), s.insurance_company.name]}.map do |k, v|
        # create claim_type if not available
        row = { claim_type: k.first, insurance: k.last, amount: v.map(&:amount).reduce(:+), count: v.count }

        @bills_summary[row[filter_key]] = @bills_summary[row[filter_key]] || {amount: 0.0, count: 0}
        @bills_summary[row[filter_key]][:amount] = @bills_summary[row[filter_key]][:amount] + row[:amount]
        @bills_summary[row[filter_key]][:count] = @bills_summary[row[filter_key]][:count] + row[:count]
        row
      end
    end

    def set_revceivables
      if params[:payment_state] && params[:payment_state] == 'no_payment'
        if params[:filter_type] && params[:filter_type] != 'Claim'
          @bills = fetch_bills_in_range([:claim_type, :insurance_company, :patient]).no_payment.
                    group_by{ |bill| bill.insurance_company.try(:name) }
        else
          @bills = fetch_bills_in_range([:claim_type, :insurance_company, :patient]).no_payment.
                    group_by{ |bill| bill.claim_type.try(:name) }
        end 
      elsif params[:filter_type] && params[:filter_type] != 'Claim'
        @bills = fetch_bills_in_range([:claim_type, :insurance_company, :patient]).receivables.
                    group_by{ |bill| bill.insurance_company.name }
      else
        @bills = fetch_bills_in_range([:claim_type, :insurance_company, :patient]).receivables.
                    group_by{ |bill| bill.claim_type.try(:name) }
      end
    end

    def set_html_elements
      @instance = @bill
      @model = "bill"
      # TODO_PROHEALTH this needs to be refactors can't use count 
      @id = Bill.count
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    def set_bills
      @bills = Bill.find(params[:id].split(','))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
      params.require(:bill).permit(:date, :amount, :patient_id,
                                   :payment_date, :paied_amount, :claim_start_date, :claim_end_date,
                                   :claim_type_id, :insurance_company_id, :from, :to, :note)
    end
end
