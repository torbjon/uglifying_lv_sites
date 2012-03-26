  $(function() {

    function some_function_name(){
      var some_variable = "";
    };

    $("input.datepicker").datepicker();
    //$( "input.datepicker" ).datepicker( "option", "dateFormat", 'dd.mm.yy' );
    
    $("form#filter select").change(function() {
      $(this).closest("form").submit();
    });

    $('#filter input').change(function() {
      if ( $('input[name$="search[tour_updated_at_more]"]').val() != '' && $('input[name$="search[tour_updated_at_less]"]').val() != '' ) {
        $(this).closest("form").submit();
      }
    });
  });