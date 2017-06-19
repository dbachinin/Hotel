# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('.datepicker').datepicker
    format: 'mm/dd/yyyy'
    weekStart: 1
    maxViewMode: 2
    todayBtn: true
    language: 'ru'
    daysOfWeekHighlighted: '0,6'
    calendarWeeks: true
    todayHighlight: true
    startDate: 0
    # datesDisabled: disa
  return