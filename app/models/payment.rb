class Payment < ActiveRecord::Base
  # associations
  belongs_to :bill
  belongs_to :patient
  belongs_to :claim_type
  belongs_to :payment_type
  belongs_to :insurance_company

  # validations
  validates :date, presence: true
  validates :amount, presence: true, numericality: { only_decimal: true }
  validates :bill_id, presence: true
  validates_associated :bill, :payment_type, :patient

  after_save :update_bill_paid_amount
  after_destroy :update_bill_paid_amount

  #scopes
  scope :range, lambda { |from, to| where(date: from..to) }

    # class methods
    def self.to_csv(payments_in_interval, payments_in_interval_grouped, payments_summary, params, filter_types, payment_recent)
      total, summary, payments = false, false, false
      attributes = if params[:total_summary] == "true"
        total  = true
         ['ID', 'Start Date', 'Discharged Date', 'Payor', 'Patient', 'Billed Amt.', 'Bill date', 'Claim', '' , '' , '' , '' , 'Claim', 'Payor', 'Amount', 'Files NO.', 'Amount', 'Files NO.']
      elsif !params[:export_summary] || params[:export_summary] == "false"
        payments = true
        ['ID', 'Start Date', 'Discharged Date', 'Payor', 'Patient', 'Billed Amt.', 'Bill date', 'Claim']
      elsif !params[:export_summary] || params[:export_summary] == "true"
        summary = true
        if filter_types.first == :claim_type then ['Claim', 'Payor', 'Amount', 'Files NO.', 'Amount', 'Files NO.'] else ['Payor', 'Claim', 'Amount', 'Files NO.', 'Amount', 'Files NO.'] end
      end
        summary_data = []
        if  summary || total
          total_payment_count = 0
          payments_in_interval_grouped.group_by{ |b| b[filter_types.first] }.each do |k, v|
            summary_data << [
              k,
              '',
              Money.new((payments_summary[k][:amount_recent] * 100 rescue(0)), 'USD').format,
              payments_summary[k][:count_recent],
              Money.new((payments_summary[k][:amount] * 100 rescue(0)), 'USD').format, 
              payments_summary[k][:count]
            ]
            v.each do |payment|
              summary_data << [
                '',
                payment[filter_types.last],
                Money.new((payment[:amount_recent] * 100 rescue(0)), 'USD').format, 
                payment[:count_recent],
                Money.new((payment[:amount] * 100 rescue(0)), 'USD').format,
                payment[:count]
              ]
            total_payment_count += payment[:count]
            end
          end
          total_amount = payment_recent ? payment_recent.sum(:amount) : 0
          total_amount_grouped = payments_in_interval_grouped.map{|s| s[:amount]}.reduce(:+).to_f.round(2).to_s
          summary_data << ['total', '', StringFormatter.format_currency(total_amount), payment_recent.count, StringFormatter.format_currency(total_amount_grouped), total_payment_count ]
        end
        length = payments_in_interval.length > (summary_data.length) ? payments_in_interval.length : (summary_data.length)
        
        CSV.generate do |csv|
          csv << ['',''," This Report for Date Range from #{params[:from]} to #{params[:to]}"]
          csv << ['','','','','','','','','','','']
          csv << attributes
          (0..(length - 1)).each do |i|
            row =  if total
               bills_aray_constructor(payments_in_interval, i) + (summary_data[i] || ['','','','','',''])
            elsif summary
              (summary_data[i] || ['','','','','',''])
            elsif payments
              bills_aray_constructor(payments_in_interval, i)
            end
          csv << row
        end
      end
    end



    def self.bills_aray_constructor(payments_in_interval, i)
      [
        payments_in_interval[i].try(:id),
        payments_in_interval[i].try(:bill).try(:claim_start_date),
        payments_in_interval[i].try(:bill).try(:claim_end_date),
        payments_in_interval[i].try(:bill).try(:insurance_company).try(:name),
        payments_in_interval[i].try(:bill).try(:patient).try(:display_name),
        payments_in_interval[i].try(:amount),
        payments_in_interval[i].try(:date),
        payments_in_interval[i].try(:bill).try(:claim_type).try(:name),
        '',
        '',
        '',
        '',
      ]
    end

  private
    def update_bill_paid_amount
      bill = self.bill
      sum = 0
      bill.update(payment_date: self.date, paied_amount: bill.payments.map(&:amount).inject{|sum,x| sum + x }.to_f)
    end
end
