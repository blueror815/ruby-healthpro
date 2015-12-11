edit_fields = [
                { label: 'Name', name: 'name' },
                { label: 'Description', name: 'description' },
                { label: 'Monthly Paid', name: 'monthly_paid', type: 'checkbox',separator: "|", options: [{ label: '', value: '1'}]}
              ];
editable_params = ['name', 'description', 'monthly_paid_0'];
columns = [
            {data :'name'},
            {data :'description'},
            {data: 'monthly_paid'}
          ];
var datatable_handler = new DataTableHandler('/claim_types', 'claim_type', '#claim-types', edit_fields, editable_params, columns, {});
