$('[name="job_type[payment_method_ids][]"]').change(function(){
  var values = []
  $('[name="job_type[payment_method_ids][]"]:checked').each(function(){
    values.push($(this).val());
  });
  if($.inArray('3', values) != -1){
    $('#job_type_salary_amount').parents('.form-group').removeClass('hide')
  }else{
    $('#job_type_salary_amount').parents('.form-group').addClass('hide')
  }
  if ($.inArray('2', values) != -1){
    $('#job_type_hour_price').parents('.form-group').removeClass('hide')
  } else {
    $('#job_type_hour_price').parents('.form-group').addClass('hide')
  }
  if ($.inArray('5', values) != -1){
    $('#job_type_on_call_price').parents('.form-group').removeClass('hide')
  } else {
    $('#job_type_on_call_price').parents('.form-group').addClass('hide')
  }
})
