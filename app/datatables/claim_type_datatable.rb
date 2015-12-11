class ClaimTypeDatatable < AjaxDatatablesRails::Base
  def sortable_columns
    @sortable_columns ||= [
      'ClaimType.name',
      'ClaimType.description'
    ]
  end

  def searchable_columns
    @searchable_columns ||= [
      'ClaimType.name',
      'ClaimType.description'
    ]
  end

  def v
    @view
  end

  private
    def data
      records.map do |record|
        {
          :name => record.name,
          :description => record.description,
          :monthly_paid => record.monthly_paid,
          "DT_RowId" => record.id.to_s
        }
      end
    end

    def get_raw_records
      ClaimType.all
    end
end
