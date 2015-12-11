$(function() {
  $('[class="fc-toolbar"]').attr('class', 'card-head style-primary');
  $('.fc-view-container').addClass('card-body');
  $('.fc-right > .fc-button-group').attr('class', 'tools');
  $('#calendar .tools').unwrap();
  //$('.fc-center > h2').unwrap();
  $('.fc-prev-button').attr('id', 'calender-prev');
  $('.fc-next-button').attr('id', 'calender-next');
  $('.fc-left > .fc-button-group > .fc-button, .tools > .fc-button').attr('class', 'btn btn-icon-toggle ink-reaction');
  $('.fc-button-group').attr('class', 'btn-group');
  $('.fc-today-button').attr('class', 'fc-today-button btn btn-icon-toggle ink-reaction fc-state-disabled');

  var fc_center = $(".fc-center");
  fc_center.remove ();
  $(".fc-left").prepend(fc_center);
});




function submit_checkbox(input){

}
function setup_visit_events(){
  $(".task_checkbox").change(function(){
    if ($(this).is(":checked") == true) {
      $("#update_task input[value=" + $(this).val() +"]").prop('checked', true) 
    }else{
      $("#update_task input[value=" + $(this).val() +"]").prop('checked', false) 
    }
  })
  


  $(".comment-icon").click(function(){
    var el = $(this);
    var rid = $(this).data("rid");
    var selector = '[data-rid="' + rid +'"]'; 
    var comment_field = $('.comment-field' + selector);


    if(comment_field.val() != ""){
      swal({
            title: "",
            text: "Please leave a justification comment",
            type: "input",
            showCancelButton: true,
            closeOnConfirm: false,
            animation: "slide-from-top",
            inputValue: comment_field.val(),

        }, function(inputValue) {
            if (inputValue === false){
              return false;
            }
            if (inputValue === "") {
              swal.showInputError("You need to leave a comment");
              return false
            }
            
            comment_field.val(inputValue);
            setTimeout(function(){
              el.parents('form.edit-visit').submit();
            }, 100);
         
            swal.close();
            
        });
    }else{

    }


  })

  $('.edit-visit .single_instance').click(function(){ 
    var el = $(this);
    var rid = $(this).data("rid");
    var selector = '[data-rid="' + rid +'"]'; 
    var comment_field = $('.comment-field' + selector);
    var checkbox_field = $('.single_instance' + selector);
    var comment_icon = $('.comment-icon' + selector + " i");
    if (this.checked){

      swal({
            title: "",
            text: "Please leave a justification comment",
            type: "input",
            showCancelButton: true,
            closeOnConfirm: false,
            animation: "slide-from-top",
            inputPlaceholder: "Details.."
        }, function(inputValue) {
            if (inputValue === false){
              checkbox_field.attr('checked', false);
              comment_field.val('');
          

              setTimeout(function(){
                el.parents('form.edit-visit').submit();
              }, 100);
              return false;
            }
            if (inputValue === "") {
              swal.showInputError("You need to leave a comment");
              return false
            }
            comment_icon.toggleClass("text-default");
            comment_icon.toggleClass("text-primary");
            comment_field.val(inputValue);
            setTimeout(function(){
           
              el.parents('form.edit-visit').submit();
            }, 100);
         
            swal.close();
            
        });
    }
    else{
      comment_field.val("");
      comment_icon.addClass("text-default");
      comment_icon.removeClass("text-primary");
      setTimeout(function(){
        el.parents('form.edit-visit').submit();
      }, 100);
    }
  })

  $('.edit-visit .multiple-instance').change(function(){ 
    var el = $(this);
    var v = this.value
    var prev = $(this).data("count")
    var rid = $(this).data("rid");
    var selector = '[data-rid="' + rid +'"]'; 
    var comment_field = $('.comment-field' + selector);
    var number_field = $('.multiple_instance' + selector);
    var comment_icon = $('.comment-icon' + selector + " i");
    
    if(prev==0 && v > 0){
      swal({
          title: "Reimbursement Justification",
          text: "Please leave a justification comment",
          type: "input",
          showCancelButton: true,
          closeOnConfirm: false,
          animation: "slide-from-top",
          inputPlaceholder: "Details.."
      }, function(inputValue) {
          if (inputValue === false) {
              el.val("0");
              comment_field.val("");
              
              el.data("count", "0");
              

              return false;
          }
          if (inputValue === "") {
            swal.showInputError("You need to leave a comment");
            return false
          }
          console.log(JSON.stringify(comment_icon))
          comment_icon.toggleClass("text-default");
          comment_icon.toggleClass("text-primary");
          comment_field.val(inputValue);
          setTimeout(function(){
            el.parents('form.edit-visit').submit();
          }, 100);
       
          swal.close();
        
      });
    }

    else if(v == 0){
      comment_field.val("");
      comment_icon.toggleClass("text-default");
      comment_icon.toggleClass("text-primary");
      setTimeout(function(){
        el.parents('form.edit-visit').submit();
      }, 100);
    }

    else{
    $(this).parents('form.edit-visit').submit();
    }

    el.data("count", v);
  })
}

function setup_card_collapse(){
  var _handleCardCollapse = function (e) {
    var card = $(e.currentTarget).closest('.card');
    materialadmin.AppCard.toggleCardCollapse(card);
  };
  $('.card-head .tools .btn-collapse').on('click', function (e) {
    _handleCardCollapse(e);
  });
}


function setup_offcanvas_events(){
  o = window.materialadmin.AppOffcanvas;
  $('.offcanvas').on('refresh', function (e) {o.evalScrollbar(e);});
  $('[data-toggle="offcanvas"]').on('click', function (e) {
  e.preventDefault();
  o._handleOffcanvasOpen($(e.currentTarget));
  });$('[data-dismiss="offcanvas"]').on('click', function (e) {
  o._handleOffcanvasClose();
  });
  $('#base').on('click', '> .backdrop', function (e) {
  o._handleOffcanvasClose();
  });

  // Open active offcanvas buttons
  $('[data-toggle="offcanvas-left"].active').each(function () {
  o._handleOffcanvasOpen($(this));
  });
  $('[data-toggle="offcanvas-right"].active').each(function () {
  o._handleOffcanvasOpen($(this));
  });
}


function offfcanvasDatatableInit(tableKey){
  var table =  $(tableKey).DataTable({
        paging: false,
        select: true
      });
    new $.fn.dataTable.Buttons( table, {
        buttons: [
            {
                text: 'Select All',
                action: function ( e, dt, node, conf ) {
                    console.log( 'Button 1 clicked on' );
                }
            },
            {
                text: 'Add',
                action: function ( e, dt, node, conf ) {
                    console.log( 'Button 2 clicked on' );
                }
            }
        ]
    } );
    table.buttons( 0, null ).container().prependTo(
        table.table().container()
    );
}
