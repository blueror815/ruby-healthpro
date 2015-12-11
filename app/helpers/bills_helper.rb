module BillsHelper
  def interval_amount_sum(records, from, to, args = nil)
    amnt = interval_amount_sum_int(records, from, to, args = nil)
    number_to_currency((amnt || 0 ))
  end

  def interval_amount_sum_int(records, from, to, args = nil)
    args ||= params
    to = args[:to].to_date - to.days
    from = args[:to].to_date - from.days
    records.select{ |b| b.date > from && b.date < to }.
                        map(&:receivable_amount).reduce(:+)
  end

end
