$(document).ready(function(){
  $(".datatableAutoInitializer").DataTable({});

  $('#date input, .datePickerField').datepicker({
    format: 'YYYY/MM/DD'
  });

  // Editing checkbox input
  $("input[type='hidden']+span").remove();
  
  // Initiating datepicker
  $('.input-daterange').datepicker({ format: 'yyyy-mm-dd' });

  // Initiating SweetAlert
  $('.swal.swal-delete').click(function(e){
    $('button.cancel').css('display', '')
    e.preventDefault();
    e.stopPropagation();
    var that = $(this);
    swal({
        title: "Are you sure?",
        text: "You will not be able to recover this item!",
        type: "warning",
        showCancelButton: true,
       
        confirmButtonText: 'Yes, delete!',
        cancelButtonText: "No, cancel!",
        closeOnConfirm: true,
        closeOnCancel: false
    },
    function (isConfirm) {
      if (isConfirm) {
        // swal("Deleted!", "", "success");
        that.next().click();
      } else {
        swal("Cancelled", "", "error");
      }
    });
  })
  
  $('select').select2();
  
  $(".numbers_only").numeric();

  // Hide comments area if there's no comments.
  if ( $('ul[id$="comments"]').children().length == 0 ) {
    $('ul[id$="comments"]').hide();
  };

})

  $(function () {
    $('.char_count').characterCounter({
      limit: '60'
    });
    
    $('.people-table th:first-child').attr('class', 'sorting_asc');


    $(".submit-action").click(function(){
      var form_id = $(this).data("form-id")
      var form;

      if(form_id == "id"){
        form = $("form")
      }
      else{
        form = $("#" + form_id);
      }
      form.submit();  
    });

    var e = $(".tab-content .tab-pane .dl-horizontal dd .hide-overflow");
    $.each(e, function(i, v){
       
      var t = $.trim($(v).text());
      
      if(t.length > 100){
        $(v).text(t.substr(0,100) + " ...");
      }
    });
 

  });