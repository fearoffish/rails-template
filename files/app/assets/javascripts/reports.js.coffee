$ ->
  $('#report_form_wrapper').show()
  $('.loading').hide()
  if $('#report_total_procedures').data('creating') == true
    
  else
    $('.new_report .report_report_date').hide()
    $('#categories').hide()

  $(".new_report #report_facility_id").change ->
    facility_id = $("#report_facility_id option:selected").val()
    if facility_id != "" 
      $('.new_report .report_report_date').show()
    else
      $('#report_report_date').val('0')
      $('#categories').hide()
      $('.new_report .report_report_date').hide()
  $(".new_report #report_report_date").change ->
    facility_id = $("#report_facility_id option:selected").val()
    report_date = $("#report_report_date option:selected").val()
    if facility_id == "" || report_date == ""
      $('#categories').hide()
    else
      if report_date != "" and facility_id != ""
        $.getJSON "/reports/find_or_new.json?facility_id=#{facility_id}&report_date=#{report_date}", (data) ->
          if data.id
            document.location.href = "/reports/find_or_new?facility_id=#{facility_id}&report_date=#{report_date}"
          else
            $('#categories').show()