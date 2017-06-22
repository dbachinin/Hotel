# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#datepicker').datepicker
    format: 'yyyy-mm-dd'
    todayBtn: true
    language: 'ru'
    daysOfWeekHighlighted: '0,6'
    todayHighlight: true
    datesDisabled: disa
    autoclose: true


    # $(document).ready ->
    #   $('#datepicker').datepicker
    # format: 'yyyy-mm-dd'
    # autoclose: true
    # weekStart: 1
    # maxViewMode: 2
    # todayBtn: true
    # language: 'ru'
    # daysOfWeekHighlighted: '0,6'
    # calendarWeeks: true
    # todayHighlight: true
    # # datesDisabled: disa


  # $(document).ready ->
  # $('input[class="daterange"]').daterangepicker()
  # return