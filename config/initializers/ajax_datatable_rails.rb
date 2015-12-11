include ActiveRecord::Sanitization::ClassMethods	

AjaxDatatablesRails::Base.class_eval do
   def new_sort_column(item)
     begin
        model, column = sortable_columns[sortable_displayed_columns.index(item[:column])].split('.')
      rescue 
        model, column = sortable_columns[sortable_displayed_columns.index(params[:columns][item[:column]]['data'])].split('.')
      end
      col = [model.constantize.table_name, column].join('.')
   end

   def new_search_condition(column, value)
     model, column = column.split('.')
     model = model.constantize
     casted_column = ::Arel::Nodes::NamedFunction.new('CAST', [model.arel_table[column.to_sym].as(typecast)])
     if (value.start_with?('filterkey:'))
      value = value.gsub('filterkey:', '')
      casted_column.matches("#{sanitize_sql_like(value)}")
     elsif (value.start_with?('date:'))
      value = value.gsub('date:', '').to_date.to_s
      casted_column.matches("#{sanitize_sql_like(value)}")
     else
     	casted_column.matches("%#{sanitize_sql_like(value)}%")
     end
   end

   def deprecated_search_condition(column, value)
     model, column = column.split('.')
     model = model.singularize.titleize.gsub( / /, '' ).constantize
     casted_column = ::Arel::Nodes::NamedFunction.new('CAST', [model.arel_table[column.to_sym].as(typecast)])
     if (value.start_with?('filterkey:'))
      value = value.gsub('filterkey:', '')
      casted_column.matches("#{sanitize_sql_like(value)}")
     elsif (value.start_with?('date:'))
      value = value.gsub('date:', '').to_date.to_s
      casted_column.matches("#{sanitize_sql_like(value)}")
     else
     	casted_column.matches("%#{sanitize_sql_like(value)}%")
     end
   end
end

# AjaxDatatablesRails.configure do |config|
#   # available options for db_adapter are: :oracle, :pg, :mysql2, :sqlite3
#   config.db_adapter = :pg

#   # available options for paginator are: :simple_paginator, :kaminari, :will_paginate
#   config.paginator = :kaminari
# end