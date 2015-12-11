class InsuranceCompanyDatatable < AjaxDatatablesRails::Base
  def sortable_columns
    @sortable_columns ||= [
      'InsuranceCompany.name',
      'InsuranceCompany.description'
    ]
  end

  def searchable_columns
    @searchable_columns ||= [
      'InsuranceCompany.name',
      'InsuranceCompany.description'
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
          "DT_RowId" => record.id.to_s
        }
      end
    end

    def get_raw_records
      InsuranceCompany.all
    end
end
