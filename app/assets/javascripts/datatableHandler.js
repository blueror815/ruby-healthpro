var DataTableHandler = function(url, model, table_id, edit_fields, editable_fields, columns, options) {
  this.url = url;
  this.model =  model;
  this.edit_fields = edit_fields;
  this.columns = columns;
  this.table_id = table_id;
  this.editable_params = editable_fields;
  this.dt_options = options;
  this.dt_obj;
  this.editor;
  this.init_datatable();
};
DataTableHandler.prototype.init_datatable = function(){

  //init editor 
  editor = new $.fn.dataTable.Editor( {
    ajax:  {
      create: {
        url: this.url, 
        type: 'POST',
        data: function(d) {
          d[datatable_handler.model] = {};
          for ( var item in datatable_handler.editable_params ) {
            param = datatable_handler.editable_params[item]
            attr_name = param.split('_0')[0]
            attr_val  = $("#DTE_Field_" + param).val()
            if (param.split('_0').length > 1)
            {
              attr_val = $("#DTE_Field_" + param).is(":checked") - 0
            }
            d[datatable_handler.model][attr_name] = attr_val;
          }
        }
      },
      edit: {
        url: this.url+'/_id_', 
        type: 'PATCH',
        data: function(d) {
          d[datatable_handler.model] = {};
          for ( var item in datatable_handler.editable_params ) {
            param = datatable_handler.editable_params[item]
            attr_name = param.split('_0')[0]
            attr_val  = $("#DTE_Field_" + param).val()
            if (param.split('_0').length > 1)
            {
              attr_val = $("#DTE_Field_" + param).is(":checked") - 0
            }
            d[datatable_handler.model][attr_name] = attr_val;
          }
        }
      },
      remove: {
        url: this.url+'/_id_', 
        type: 'DELETE',
        data: function(d) {
         d[datatable_handler.model] = {};
          for ( var item in datatable_handler.editable_params ) {
            param = datatable_handler.editable_params[item]
            attr_name = param.split('_0')[0]
            attr_val  = $("#DTE_Field_" + param).val()
            if (param.split('_0').length > 1)
            {
              attr_val = $("#DTE_Field_" + param).is(":checked") - 0
            }
            d[datatable_handler.model][attr_name] = attr_val;
          }
        }
      }
    },
    table: this.table_id,
    fields: this.edit_fields
  });
  this.editor = editor

  buttons = []
  if (this.dt_options['showButtons'] == undefined || 
      this.dt_options['showButtons'] == true){
      buttons =  [
                  { extend: "create", editor: editor },
                  { extend: "edit",   editor: editor },
                  { extend: "remove", editor: editor }
                 ]
    }


  // init datatable

  default_dt_op = {
    "processing": true,
    "serverSide": true,
    "ajax": this.url ,
    "dom": 'Bfrtip',
    "order": [],
    columns: this.columns ,
    select: true,
    buttons: buttons
  }


  editor.on("open", function(a, b, c){
    $("select").select2();
  });


  this.dt_options = $.extend(default_dt_op, this.dt_options) 
  this.dt_obj = $(this.table_id).DataTable(this.dt_options);
}
