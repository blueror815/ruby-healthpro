class AvailabilityDatatable < AjaxDatatablesRails::Base
  include ApplicationHelper
  def_delegator :@view, :link_to, :availability_path

  def sortable_columns
    @sortable_columns ||= ['Availability.name', 'Availability.description']
  end

  def searchable_columns
    @searchable_columns ||= ['Availability.name', 'Availability.description']
  end

  private
    def v
      @view
    end

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
      Availability.all
    end
end
