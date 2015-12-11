class ReimbursementDatatable < AjaxDatatablesRails::Base
  def sortable_columns
    @sortable_columns ||= [
                            'Reimbursement.title',
                            'Reimbursement.price',
                            'Reimbursement.value_type',
                            'Reimbursement.include_in_timesheet'
                          ]
  end

  def searchable_columns
    @searchable_columns ||= [
                            'Reimbursement.title',
                            'Reimbursement.price',
                            'Reimbursement.value_type',
                            'Reimbursement.include_in_timesheet'
                          ]

  end

  private
    def v
      @view
    end

    def data
      records.map do |record|
        {
          :title => record.title,
          :price => StringFormatter.format_currency(record.price),
          :value_type_text => Reimbursement::TYPES[record.value_type],
          :value_type => record.value_type,
          :include_in_timesheet => record.include_in_timesheet,
          "DT_RowId" => record.id
        }
      end
    end

    def get_raw_records
      Reimbursement.all
    end
end
