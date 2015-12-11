class Bill < ActiveRecord::Base
  require 'money'

  # associations
  belongs_to :patient
  belongs_to :claim_type
  belongs_to :insurance_company
  has_many :payments, dependent: :destroy

  # validations
  validates :date, presence: true
  validates :patient_id, presence: true
  validates :claim_start_date, presence: true
  validates :claim_end_date, presence: true
  validates :claim_type_id, presence: true
  validates :insurance_company, presence: true
  validates :amount, presence: true, numericality: { only_decimal: true }
  validate :claim_start_and_end_dates

  #scopes
  scope :today, -> { where('created_at > ?', (DateTime.yesterday)) }
  scope :range, lambda { |from, to| where(date: from..to) }
  scope :receivables, -> { where('((amount - paied_amount) > 1.0)') }
  scope :no_payment, -> { where('paied_amount = 0') }
  

  def self.debug(msg)
    #puts msg
  end
  # class methods
  def self.to_csv(records)
    attributes = ['ID', 'Start Date', 'End Date', 'Claim Type', 'Payor', 'Patient Name', 'Billed Amt.',
                    'Bill Date', 'Paid Amt.', 'Paid Date', 'Notes']

    CSV.generate do |csv|
      csv << attributes
        records.each do |bill|
          csv << [ 
                  bill.id,
                  bill.claim_start_date,
                  bill.claim_end_date,
                  bill.claim_type.try(:name),
                  bill.insurance_company.try(:name),
                  bill.patient.display_name,
                  bill.amount,
                  bill.date,
                  bill.paied_amount,
                  bill.payment_date,
                  bill.note
                 ]
      end
    end
  end

  # set comma containing attribute for xls exporting
  comma do
    patient :display_name
    insurance_company :name
  end

  def self.row_to_json(header, row)
    {
      patient_name: row[header.index('Patient Name')],
      payor: row[header.index('Payor')],
      claim: row[header.index('Claim')],
      soc_date: row[header.index('SOC Date')],
      through_date: row[header.index('Through Date')],
      bill_amount: row[header.index('Billed Amt')],
      bill_date: row[header.index('Billed Date')],
      paid_amount: row[header.index('Paid Amt')],
      paid_date: row[header.index('Paid Date')],
      notes: row[header.index('Notes')]
    }
  end

  def self.parse_patient(row)
    display_name = row[:patient_name].try(:downcase).try(:titleize)
    patient = Patient.where(display_name: display_name).first_or_create

    if !row[:soc_date].blank? and row[:soc_date].try(:to_date)
      if patient.try(:soc_date) == nil or patient.try(:soc_date) > row[:soc_date].try(:to_date)
        patient.update(soc_date: row[:soc_date].try(:to_date))
      end
    end
    patient
  end

  def self.import(file_path)
    file = File.open(file_path)

    spreadsheet = open_spreadsheet(file).sheet('Billing')
    header = spreadsheet.row(1).reject(&:nil?).map(&:strip)

    (2..spreadsheet.last_row).each do |i|
      begin
        row = row_to_json(header, spreadsheet.row(i))
        debug ">> Inserting Bill Row: " + row.to_json.to_s
        claim = ClaimType.where(name: row[:claim].try(:strip)).first_or_create
        payor = row[:payor].try(:downcase).try(:titleize)
        insurance_company = InsuranceCompany.where(uniq_name: payor.try(:downcase), name: payor).first_or_create
        patient = self.parse_patient(row)
        patient.insurance_companies << insurance_company unless patient.insurance_companies.include?(insurance_company)

        row_claim_start_date = row[:soc_date].try(:to_date) || patient.try(:soc_date) || (Date.today - 1.day)
        row_claim_end_date = row[:through_date].try(:to_date) || patient.try(:discharged_date) || Date.today   

        bill = Bill.where({
                       amount: row[:bill_amount],
                       date: row[:bill_date].try(:to_date),
                       insurance_company_id: insurance_company.try(:id),
                       claim_start_date: row_claim_start_date,
                       claim_end_date: row_claim_end_date,
                       note: row[:notes],
                       claim_type_id: claim.id,
                       patient_id: patient.try(:id)}).first_or_create
       
        if bill.persisted?
          debug "bill was created successfully adding payments"
          begin

            if row[:paid_amount].to_f.abs > 0.0 #no paid amount
              debug "bill has a payment"
              payment = Payment.create(
                amount: row[:paid_amount], 
                date: row[:paid_date].try(:to_date), 
                bill_id: bill.id,
                patient_id: patient.id, 
                insurance_company: insurance_company, 
                claim_type_id: claim.id)
              bill.payments << payment
              
            else
              debug "bill has no payments"
            end
          rescue  Exception => error
            puts "Faild to Insert payment"
            puts error.to_s
          end
        else
          debug "Bill wasn't saved"  
        end

      rescue => error
        puts "Failed To Insert Bill! row number #{i}"
        puts error.to_s
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.path)
    when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
    when ".xls" then Roo::Spreadsheet.open(file.path)
    when ".xlsm" then Roo::Spreadsheet.open(file.path)
    when ".xlsx" then Roo::Spreadsheet.open(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  # instance methods
  def receivable_amount
    self.amount - self.paied_amount
  end

  def self.receivables_csv(records, params, filter_types)
    CSV.generate do |csv|
      csv << ['',''," This Report for Date Range from #{params[:from]} to #{params[:to]}"]
      csv << ['','','','','','','','','','','']

      if !params[:export_summary] || params[:export_summary] == "false"
        csv << [
                'ID',
                'Start Date',
                'End Date',
                'Claim Type',
                'Payor',
                'Patient Name',
                'Billed Amt.',
                'Bill Date',
                'Paid Amt.',
                'Paid Date',
                'Notes'
               ]
        records.values.flatten.each do |bill|
          csv << [
                  bill.id,
                  bill.claim_start_date,
                  bill.claim_end_date,
                  bill.claim_type.try(:name),
                  bill.insurance_company.try(:name),
                  bill.patient.display_name,
                  bill.amount,
                  bill.date,
                  bill.paied_amount,
                  bill.payment_date,
                  bill.note
                 ]
        end
        csv << ['','','','','','','','','','','']
        csv << ['','','','','','','','','','','']
      end
      if !params[:export_summary] || params[:export_summary] == "true"
        attributes = if filter_types.first == :claim_type then ['Claim Type', 'Insurence company', 'Amount', 'Count', '0-10 days', '11-20 days', '21-30 days', '31-60 days', '60+ days'] else ['Insurence company', 'Claim Type','Amount', 'Count', '0-10 days', '11-20 days', '21-30 days', '31-60 days', '60+ days'] end
        csv << attributes
        total_count = 0
        records.each do |grouping_key, bills|
          if filter_types.first == :claim_type
            grouped_bills = bills.group_by{ |bill| bill.insurance_company.try(:name) }
          else
            grouped_bills = bills.group_by{ |bill| bill.claim_type.try(:name) }
          end
          total_count += bills.count
          csv << [
                  grouping_key,
                  nil,
                  Money.new((bills.map(&:receivable_amount).reduce(:+) * 100 rescue(0)), "USD").format,
                  bills.count,
                  interval_amount_sum(bills, 10, 0, params),
                  interval_amount_sum(bills, 20, 11, params),
                  interval_amount_sum(bills, 30, 21, params),
                  interval_amount_sum(bills, 60, 31, params),
                  Money.new((bills.select{ |b| b.date < (params[:to] - 60.days) }.
                                            map(&:receivable_amount).reduce(:+) * 100 rescue(0)), "USD").format
                ]
          grouped_bills.each do |grouping_value, records|
            csv << [ 
                    nil,
                    grouping_value,
                    Money.new((records.map(&:receivable_amount).reduce(:+).to_f * 100 rescue(0)), "USD").format,
                    records.count,
                    interval_amount_sum(records, 10, 0, params),
                    interval_amount_sum(records, 20, 11, params),
                    interval_amount_sum(records, 30, 21, params),
                    interval_amount_sum(records, 60, 31, params),
                    Money.new((records.select{ |b| b.date < (params[:to] - 60.days) }.
                                                map(&:receivable_amount).reduce(:+) * 100 rescue(0)), "USD").format
                   ]
          end
        end
        csv << [
                'Total',
                '',
                Money.new((records.values.flatten.map(&:receivable_amount).reduce(:+) * 100 rescue(0)), "USD").format,
                total_count,
                interval_amount_sum(records.values.flatten, 10, 0, params),
                interval_amount_sum(records.values.flatten, 20, 11, params),
                interval_amount_sum(records.values.flatten, 30, 21, params),
                interval_amount_sum(records.values.flatten, 60, 31, params),
                Money.new((records.values.flatten.select{ |b| b.date < (params[:to] - 60.days) }.
                                                          map(&:receivable_amount).reduce(:+) * 100 rescue(0)), "USD").format
               ]

        3.times { csv << [] }
      end
    end
  end

  def self.reports_csv(records, bills, bills_summary, params, filter_types)
    total, summary, bills_table = false, false, false
    if params[:export_summary] == "true"
      summary  = true
      attributes = if filter_types.first == :claim_type then ['Claim Type', 'Payor', 'Amount', 'Files No.'] else ['Payor', 'Claim Type', 'Amount', 'Files No.'] end
    elsif params[:export_summary] == "false"
      bills_table = true
      attributes = ['ID', 'Start Date', 'Discharged Date', 'Bill Type', 'Payor', 'Patient', 'Billed Amt.', 'Bill date']
    elsif !params[:export_summary]
      total = true
      attributes = ['ID', 'Start Date', 'Discharged Date', 'Bill Type', 'Payor', 'Patient', 'Billed Amt.', 'Bill date', '', '', 'Claim Type', 'Payor', 'Amount', 'Files No.']
    end

    summary_data = []
    if  summary || total
      bills.group_by{ |b| b[filter_types.first] }.each do |k, v|
        summary_data << [
          k,
          '',
          Money.new((bills_summary[k][:amount] * 100 rescue(0)), "USD").format,
          bills_summary[k][:count]
        ]
        v.each do |bill|
          summary_data << [
            '',
            bill[filter_types.last],
            Money.new(bill[:amount] * 100, "USD").format,
            bill[:count],
          ] 
        end
      end
      summary_data << [
        'Total',
        '',
        Money.new((records.map(&:amount).reduce(:+) * 100  rescue(0)), "USD").format,
        bills.map{|b| b[:count]}.reduce(:+)
      ]
    end

    length = records.length > (summary_data.length) ? records.length : (summary_data.length)

    CSV.generate do |csv|
        csv << ['',''," This Report for Date Range from #{params[:from]} to #{params[:to]}"]
        csv << ['','','','','','','','','','','']
        csv << attributes
        (0..(length - 1)).each do |i|
          row =  if total
             bills_aray_constructor(records, i) + (summary_data[i] || ['',''])
          elsif summary
            summary_data[i]
          elsif bills_table
            bills_aray_constructor(records, i)
          end
        csv << row if row
      end
    end
  end

  def self.bills_aray_constructor(bills, i)
    [
      bills[i].try(:id),
      bills[i].try(:claim_start_date),
      bills[i].try(:claim_end_date),
      bills[i].try(:claim_type).try(:name),
      bills[i].try(:insurance_company).try(:name),
      bills[i].try(:patient).try(:display_name),
      bills[i].try(:amount),
      bills[i].try(:date),
      '',
      ''
    ]
  end

  def self.interval_amount_sum(records, from, to, args = nil)
    args ||= params
    to = args[:to].to_date - to.days
    from = args[:to].to_date - from.days
    Money.new((records.select{ |b| b.date > from && b.date < to }.
                        map(&:receivable_amount).reduce(:+) * 100 rescue(0)), "USD").format
  end

  private
    def claim_start_and_end_dates
      if claim_end_date && claim_start_date
        errors.add(:claim_end_date, "cannot be older than Claim start date") if claim_end_date < claim_start_date
      end
    end
end
