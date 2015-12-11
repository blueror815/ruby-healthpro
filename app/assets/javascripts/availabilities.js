edit_fields = [
                { label: 'Name', name: 'name' },
                { label: 'Description', name: 'description' }
              ];
editable_params = ['name', 'description'];
columns = [
            {data :'name'},
            {data :'description'}
          ];
var datatable_handler = new DataTableHandler('/availabilities', 'availability', '#availabilities-table', edit_fields, editable_params, columns, {});
