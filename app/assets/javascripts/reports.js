$(function(){
    field_type = $("select.field_type_select").length
    emptyContainerAppearance(field_type);
    $(".field_type_form." + field_type + "-form").show();
    $(".field_type_select").change(function(e){
        if(e.added){
            var field_type = e.added.id.replace('(', '').replace(')', '');
            emptyContainerAppearance(field_type);
            $(".field_type_form").hide();
            $(".field_type_form." + field_type + "-form").show();
        }
    });

    $('#report_custom_form_id, select.field_type_select').change(function(){
        $.ajax({
            url: "/reports/get_form_fields",
            type: "GET",
            data: { custom_form_id: $("#report_custom_form_id").val(), field_type: $("select.field_type_select").val() }
        });

        $.ajax({
            url: "/reports/get_field_aliases",
            type: "GET",
            data: { custom_form_id: $("#report_custom_form_id").val(), field_type: $("select.field_type_select").val() }
        });        
    });

    $('select.field_type_select').change(function(){
        clearValues(this);
    });

    $('#report_custom_form_id').change(function () {
        $.ajax({
            url: "/reports/get_field_basic_types",
            type: "GET",
            data: { custom_form_id: $("#report_custom_form_id").val()}
        });
    });

    $("custom_form_select")
});

function emptyContainerAppearance(field_type){
    if (field_type == 'boolean'){
        $('.include_empty_container').addClass('hide');
        $('.option_fields').addClass('hidden');
        $('.boolean_fields').removeClass('hidden');
    }else if (field_type == 'date' || field_type == 'expirable_file'){
        $('.include_empty_container').removeClass('hide');
        $('.option_fields').addClass('hidden');
        $('.days_fields').removeClass('hidden');

    }else if (field_type == 'date_interval') {
        $('.include_empty_container').removeClass('hide');
        $('.option_fields').addClass('hidden');
        $('.interval_fields').removeClass('hidden');
    }else if (field_type == 'file') {
        $('.include_empty_container').removeClass('hide');
        $('.option_fields').addClass('hidden');
        $('.interval_fields').addClass('hidden');
    }
}

function clearValues(ele){
    $('.option_fields input').val('');
}
