function add_fields(link, association, content) {
  var new_id = parseInt($(link).attr('id'))
  $(link).attr('id', ++new_id)
  if( association.indexOf('fields') >= 0 ){
    $(link).parents().eq(1).prev().find('tbody').append(content.replace(/\[section_fields_attributes\]\[\d+\]/g, ('[section_fields_attributes]['+new_id+']')).replace(/fields-[0-9]/g,('fields-'+new_id)));
    $(link).parents().eq(1).prev().find('tbody').children().last().find(".checkbox-styled").each(function(){$(this).find('[type="check1box"]').after("<span></span>")});
  }else if(association.indexOf('sections') >= 0) {
    $(link).before(content.replace(/edit-sectioncustom_form-sections-[0-9]/g, ('edit-sectioncustom_form-sections-'+new_id)).replace(/sections\[[0-9]\]/g, ('sections['+new_id+']')).replace('/fields-[0-9]/g',('fields-'+new_id)));
    //some checkboxes do not get spans after them
  }
  $('.box-body [type="checkbox"],.modal-content [type="checkbox"]').each(function(){
    if(!$(this).next().is('span')){
      $(this).after("<span></span>");
    }
  });
  $('select').select2()
  $('.fields-table').trigger('rowChange');
}

function remove_fields(link, element) {
  $('button.cancel').css('display', '')
  swal({
      title: "Are you sure?",
      text: "You will not be able to recover this item!",
      type: "warning",
      showCancelButton: true,
      confirmButtonText: 'Yes, delete!',
      cancelButtonText: "No, cancel!",
      closeOnConfirm: true,
      closeOnCancel: true
  },
  function (isConfirm) {
    if (isConfirm) {
      if (typeof (id = element.split('_')[1]) !== 'undefined') {
        $('select#custom_form_ids, select#custom_form_id').select2()
        option = $('select#custom_form_ids').find('option[value="' + element.split('_')[1] + '"]')
        $('select#custom_form_id').append(new Option($(option).html(), $(option).val()))
        $(option).removeAttr('selected');
        $('select#custom_form_ids, select#custom_form_id').select2()
        $(link).parents(element.split('_')[0]).remove();
        swal("Deleted!", "", "success");
      }else if (element == 'NULL'){
        $(link).next().removeClass('hide')
        $(link).next().click()
      }else{
        $(link).next().removeClass('hide')
        $(link).next().click()
        $(link).parents(element).remove();
        swal("Deleted!", "", "success");
      }
    }
  });
  $('.fields-table').trigger('rowChange');
}

function remove_section_field(link, element) {
  $('button.cancel').css('display', '')
  swal({
      title: "Are you sure?",
      text: "You will not be able to recover this item!",
      type: "warning",
      showCancelButton: true,
      confirmButtonText: 'Yes, delete!',
      cancelButtonText: "No, cancel!",
      closeOnConfirm: true,
      closeOnCancel: true
  },
  function (isConfirm) {
    if (isConfirm) {
      $(link).next().removeClass('hide');
      $(link).parents(element).find('.destroy-field')[0].value = true;
      $(link).parents(element).hide();
    }
    swal("Deleted!", "", "success");
  });
  $('.fields-table').trigger('rowChange');
}

function remove_form(link, form_datum_id) {
  $('button.cancel').css('display', '')
  swal({
      title: "Are you sure?",
      text: "You will not be able to recover this item!",
      type: "warning",
      showCancelButton: true,
      confirmButtonText: 'Yes, delete!',
      cancelButtonText: "No, cancel!",
      closeOnConfirm: true,
      closeOnCancel: true
  },
  function (isConfirm) {
    if (isConfirm) {
      custom_form_name = $('#form-tabs li#' + $(link).attr('id') + ' a').html();
      custom_form_id = $(link).attr('id');
      $('#form-tabs li#' + $(link).attr('id')).remove();
      destroy_field = $(link).parent().parent().find('.destroy-field')
      destroy_field = destroy_field.attr('value', 'true');
      if(form_datum_id != ''){
        form_id_field = $('input[value = ' + form_datum_id + ']');
        $(link).parents('.tab-pane').replaceWith(destroy_field);
        $(destroy_field).after(form_id_field);
      } else {
        $(link).parents('.tab-pane').remove();
      }
      $('#custom_form_id').append('<option value= ' + custom_form_id + '>' + custom_form_name + '</option>');
      $('#custom_form_id').select2();
      $("#form-tabs").on("click", "a", function (e) {
        e.preventDefault();
        $(this).tab('show');
      });
      if($('#form-tabs li a').length != 0){
        $('#form-tabs li a').first().tab('show');
      }
    }
  });
  $('#form-tabs').trigger('tabChange');
}
