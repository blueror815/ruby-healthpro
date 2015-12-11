class BillingReportsController < ApplicationController
  before_action :set_date_interval_params, only: [:payments_summary]

  def payments
    from= params[:from]
    to= params[:to]
    respond_to do |format|
      format.json { render json:  Payment.all.where(date: from..to).to_json }
    end
  end

  def payments_summary
    @payments_summary = {}
    payment_recent = Payment.where(date: params[:to])
    @summary_filter_keys = if params[:filter_type] === "Claim" then [:claim_type, :insurance] else [:insurance, :claim_type] end

    @payments_recent_total = payment_recent ? payment_recent.sum(:amount) : 0
    @payments_recent_count = payment_recent.count

    @payments_in_interval = Payment.includes(:patient, bill: [:insurance_company, :claim_type]).range(params[:from], params[:to]).order(:date)
    @payments_in_interval_grouped = build_payments_reports(@payments_in_interval)

    respond_to do |format|
      format.html
      format.xls do
        from = params[:from].try(:strftime, "%d_%m_%Y")
        to = params[:to].try(:strftime, "%d_%m_%Y")
        date_range_name = (from &&  to) ? "#{from}_#{to}" : 'All'
        report_type_name = if !params['export_summary']
          'payments_insights'
        elsif params['export_summary'] == 'true'
          'payments_summary'
        else
          'payments'
        end
        filename = "#{report_type_name}_#{date_range_name}.xls"
        send_data(Payment.to_csv(@payments_in_interval, @payments_in_interval_grouped, @payments_summary, params, @summary_filter_keys, payment_recent), filename: filename )
      end 
    end
  end

  def weekly_bills_summary
  end

  def receivables_summary
  end

  private
    def build_payments_reports(payments_in_interval)
      filter_key = @summary_filter_keys.first

      payments_in_interval.group_by{|s| [s.bill.claim_type.name, s.bill.insurance_company.name]}.map do |k, v|
        payments_grouped_by_date = v.group_by{|f| f.date.strftime("%m-%d-%Y")} || [Payment.new(amount: 0)]
        payments_recent = payments_grouped_by_date[params[:to].strftime("%m-%d-%Y")]
        payments_recent_total = payments_recent ?  payments_recent.map(&:amount).reduce(:+) : 0
        payments_recent_count = payments_recent ? payments_recent.count : 0
        
        row = {
                claim_type: k.first,
                insurance: k.last,
                amount_recent: payments_recent_total,
                count_recent: payments_recent_count,
                amount: v.map(&:amount).reduce(:+),
                count: v.count
              }

        @payments_summary[row[filter_key]] = @payments_summary[row[filter_key]] || {amount: 0.0, count: 0, amount_recent: 0.0, count_recent: 0}
        @payments_summary[row[filter_key]][:amount] = @payments_summary[row[filter_key]][:amount] + row[:amount]
        @payments_summary[row[filter_key]][:count] = @payments_summary[row[filter_key]][:count] + row[:count]
        @payments_summary[row[filter_key]][:amount_recent] = @payments_summary[row[filter_key]][:amount_recent] + payments_recent_total
        @payments_summary[row[filter_key]][:count_recent] = @payments_summary[row[filter_key]][:count_recent] + payments_recent_count
        row
      end
    end
end
