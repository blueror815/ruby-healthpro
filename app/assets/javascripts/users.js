function readURL(input) {
  var reader = new FileReader();
  reader.onload = function (e) {
    $('img.img-thumbnail').attr('src', e.target.result);
  }
  reader.readAsDataURL(input.files[0]);
}

$("#imgInp").change(function(){
  readURL(this);
});

$('#custom_form_ids').select2();

$('.select2-search-choice').addClass('basically-selected');

$('#user_job_type_id').change(function(){
  var id;
  if ($('form.edit_user').length == 1) {
    id = $('form.edit_user').attr('action').split('/').pop()
  }
  $.ajax({
    url: "/job_types/" + $(this).val(),
    type: "GET",
    data: { user_id: id }
  })
})

  $(function () {
    $('#users-datatable').DataTable(
    {
      "processing": true,
      "serverSide": true,
      "ajax": $('#users-datatable').data('source'),
      "dom": 'lCfrtip',
      "order": [[ 0, "asc" ]],
      "colVis": {
        "buttonText": "Columns",
        "overlayFade": 0,
        "align": "right"
      },
      "columnDefs": [
        { className: "people-info", "targets": [ 0 ] }
      ],
      "language": {
        "lengthMenu": '_MENU_ entries per page',
        "search": '<i class="fa fa-search"></i>',
        "paginate": {
          "previous": '<i class="fa fa-angle-left"></i>',
          "next": '<i class="fa fa-angle-right"></i>'
        }
      }
    });
  });
