# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('.datepicker').datepicker
    format: 'yyyy-mm-dd'
    startDate: check_in
    weekStart: 1
    maxViewMode: 2
    todayBtn: true
    language: 'ru'
    daysOfWeekHighlighted: '0,6'
    calendarWeeks: true
    todayHighlight: true
    datesDisabled: disa
  return

  # $(document).ready ->
  # $('input[class="daterange"]').daterangepicker()
  # return