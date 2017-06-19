###*
* @version: 2.1.25
* @author: Dan Grossman http://www.dangrossman.info/
* @copyright: Copyright (c) 2012-2017 Dan Grossman. All rights reserved.
* @license: Licensed under the MIT license. See http://www.opensource.org/licenses/mit-license.php
* @website: https://www.daterangepicker.com/
###

# Follow the UMD template https://github.com/umdjs/umd/blob/master/templates/returnExportsGlobal.js
((root, factory) ->
  if typeof define == 'function' and define.amd
    # AMD. Make globaly available as well
    define [
      'moment'
      'jquery'
    ], (moment, jquery) ->
      root.daterangepicker = factory(moment, jquery)
  else if typeof module == 'object' and module.exports
    # Node / Browserify
    #isomorphic issue
    jQuery = if typeof window != 'undefined' then window.jQuery else undefined
    if !jQuery
      jQuery = require('jquery')
      if !jQuery.fn
        jQuery.fn = {}
    module.exports = factory(require('moment'), jQuery)
  else
    # Browser globals
    root.daterangepicker = factory(root.moment, root.jQuery)
  return
) this, (moment, $) ->

  DateRangePicker = (element, options, cb) ->
    `var elem`
    `var rangeHtml`
    #default settings for options
    @parentEl = 'body'
    @element = $(element)
    @startDate = moment().startOf('day')
    @endDate = moment().endOf('day')
    @minDate = false
    @maxDate = false
    @dateLimit = false
    @autoApply = false
    @singleDatePicker = false
    @showDropdowns = false
    @showWeekNumbers = false
    @showISOWeekNumbers = false
    @showCustomRangeLabel = true
    @timePicker = false
    @timePicker24Hour = false
    @timePickerIncrement = 1
    @timePickerSeconds = false
    @linkedCalendars = true
    @autoUpdateInput = true
    @alwaysShowCalendars = false
    @ranges = {}
    @opens = 'right'
    if @element.hasClass('pull-right')
      @opens = 'left'
    @drops = 'down'
    if @element.hasClass('dropup')
      @drops = 'up'
    @buttonClasses = 'btn btn-sm'
    @applyClass = 'btn-success'
    @cancelClass = 'btn-default'
    @locale =
      direction: 'ltr'
      format: moment.localeData().longDateFormat('L')
      separator: ' - '
      applyLabel: 'Apply'
      cancelLabel: 'Cancel'
      weekLabel: 'W'
      customRangeLabel: 'Custom Range'
      daysOfWeek: moment.weekdaysMin()
      monthNames: moment.monthsShort()
      firstDay: moment.localeData().firstDayOfWeek()

    @callback = ->

    #some state information
    @isShowing = false
    @leftCalendar = {}
    @rightCalendar = {}
    #custom options from user
    if typeof options != 'object' or options == null
      options = {}
    #allow setting options with data attributes
    #data-api options will be overwritten with custom javascript options
    options = $.extend(@element.data(), options)
    #html template for the picker UI
    if typeof options.template != 'string' and !(options.template instanceof $)
      options.template = '<div class="daterangepicker dropdown-menu">' + '<div class="calendar left">' + '<div class="daterangepicker_input">' + '<input class="input-mini form-control" type="text" name="daterangepicker_start" value="" />' + '<i class="fa fa-calendar glyphicon glyphicon-calendar"></i>' + '<div class="calendar-time">' + '<div></div>' + '<i class="fa fa-clock-o glyphicon glyphicon-time"></i>' + '</div>' + '</div>' + '<div class="calendar-table"></div>' + '</div>' + '<div class="calendar right">' + '<div class="daterangepicker_input">' + '<input class="input-mini form-control" type="text" name="daterangepicker_end" value="" />' + '<i class="fa fa-calendar glyphicon glyphicon-calendar"></i>' + '<div class="calendar-time">' + '<div></div>' + '<i class="fa fa-clock-o glyphicon glyphicon-time"></i>' + '</div>' + '</div>' + '<div class="calendar-table"></div>' + '</div>' + '<div class="ranges">' + '<div class="range_inputs">' + '<button class="applyBtn" disabled="disabled" type="button"></button> ' + '<button class="cancelBtn" type="button"></button>' + '</div>' + '</div>' + '</div>'
    @parentEl = if options.parentEl and $(options.parentEl).length then $(options.parentEl) else $(@parentEl)
    @container = $(options.template).appendTo(@parentEl)
    #
    # handle all the possible options overriding defaults
    #
    if typeof options.locale == 'object'
      if typeof options.locale.direction == 'string'
        @locale.direction = options.locale.direction
      if typeof options.locale.format == 'string'
        @locale.format = options.locale.format
      if typeof options.locale.separator == 'string'
        @locale.separator = options.locale.separator
      if typeof options.locale.daysOfWeek == 'object'
        @locale.daysOfWeek = options.locale.daysOfWeek.slice()
      if typeof options.locale.monthNames == 'object'
        @locale.monthNames = options.locale.monthNames.slice()
      if typeof options.locale.firstDay == 'number'
        @locale.firstDay = options.locale.firstDay
      if typeof options.locale.applyLabel == 'string'
        @locale.applyLabel = options.locale.applyLabel
      if typeof options.locale.cancelLabel == 'string'
        @locale.cancelLabel = options.locale.cancelLabel
      if typeof options.locale.weekLabel == 'string'
        @locale.weekLabel = options.locale.weekLabel
      if typeof options.locale.customRangeLabel == 'string'
        #Support unicode chars in the custom range name.
        elem = document.createElement('textarea')
        elem.innerHTML = options.locale.customRangeLabel
        rangeHtml = elem.value
        @locale.customRangeLabel = rangeHtml
    @container.addClass @locale.direction
    if typeof options.startDate == 'string'
      @startDate = moment(options.startDate, @locale.format)
    if typeof options.endDate == 'string'
      @endDate = moment(options.endDate, @locale.format)
    if typeof options.minDate == 'string'
      @minDate = moment(options.minDate, @locale.format)
    if typeof options.maxDate == 'string'
      @maxDate = moment(options.maxDate, @locale.format)
    if typeof options.startDate == 'object'
      @startDate = moment(options.startDate)
    if typeof options.endDate == 'object'
      @endDate = moment(options.endDate)
    if typeof options.minDate == 'object'
      @minDate = moment(options.minDate)
    if typeof options.maxDate == 'object'
      @maxDate = moment(options.maxDate)
    # sanity check for bad options
    if @minDate and @startDate.isBefore(@minDate)
      @startDate = @minDate.clone()
    # sanity check for bad options
    if @maxDate and @endDate.isAfter(@maxDate)
      @endDate = @maxDate.clone()
    if typeof options.applyClass == 'string'
      @applyClass = options.applyClass
    if typeof options.cancelClass == 'string'
      @cancelClass = options.cancelClass
    if typeof options.dateLimit == 'object'
      @dateLimit = options.dateLimit
    if typeof options.opens == 'string'
      @opens = options.opens
    if typeof options.drops == 'string'
      @drops = options.drops
    if typeof options.showWeekNumbers == 'boolean'
      @showWeekNumbers = options.showWeekNumbers
    if typeof options.showISOWeekNumbers == 'boolean'
      @showISOWeekNumbers = options.showISOWeekNumbers
    if typeof options.buttonClasses == 'string'
      @buttonClasses = options.buttonClasses
    if typeof options.buttonClasses == 'object'
      @buttonClasses = options.buttonClasses.join(' ')
    if typeof options.showDropdowns == 'boolean'
      @showDropdowns = options.showDropdowns
    if typeof options.showCustomRangeLabel == 'boolean'
      @showCustomRangeLabel = options.showCustomRangeLabel
    if typeof options.singleDatePicker == 'boolean'
      @singleDatePicker = options.singleDatePicker
      if @singleDatePicker
        @endDate = @startDate.clone()
    if typeof options.timePicker == 'boolean'
      @timePicker = options.timePicker
    if typeof options.timePickerSeconds == 'boolean'
      @timePickerSeconds = options.timePickerSeconds
    if typeof options.timePickerIncrement == 'number'
      @timePickerIncrement = options.timePickerIncrement
    if typeof options.timePicker24Hour == 'boolean'
      @timePicker24Hour = options.timePicker24Hour
    if typeof options.autoApply == 'boolean'
      @autoApply = options.autoApply
    if typeof options.autoUpdateInput == 'boolean'
      @autoUpdateInput = options.autoUpdateInput
    if typeof options.linkedCalendars == 'boolean'
      @linkedCalendars = options.linkedCalendars
    if typeof options.isInvalidDate == 'function'
      @isInvalidDate = options.isInvalidDate
    if typeof options.isCustomDate == 'function'
      @isCustomDate = options.isCustomDate
    if typeof options.alwaysShowCalendars == 'boolean'
      @alwaysShowCalendars = options.alwaysShowCalendars
    # update day names order to firstDay
    if @locale.firstDay != 0
      iterator = @locale.firstDay
      while iterator > 0
        @locale.daysOfWeek.push @locale.daysOfWeek.shift()
        iterator--
    start = undefined
    end = undefined
    range = undefined
    #if no start/end dates set, check if an input element contains initial values
    if typeof options.startDate == 'undefined' and typeof options.endDate == 'undefined'
      if $(@element).is('input[type=text]')
        val = $(@element).val()
        split = val.split(@locale.separator)
        start = end = null
        if split.length == 2
          start = moment(split[0], @locale.format)
          end = moment(split[1], @locale.format)
        else if @singleDatePicker and val != ''
          start = moment(val, @locale.format)
          end = moment(val, @locale.format)
        if start != null and end != null
          @setStartDate start
          @setEndDate end
    if typeof options.ranges == 'object'
      for range of options.ranges
        `range = range`
        if typeof options.ranges[range][0] == 'string'
          start = moment(options.ranges[range][0], @locale.format)
        else
          start = moment(options.ranges[range][0])
        if typeof options.ranges[range][1] == 'string'
          end = moment(options.ranges[range][1], @locale.format)
        else
          end = moment(options.ranges[range][1])
        # If the start or end date exceed those allowed by the minDate or dateLimit
        # options, shorten the range to the allowable period.
        if @minDate and start.isBefore(@minDate)
          start = @minDate.clone()
        maxDate = @maxDate
        if @dateLimit and maxDate and start.clone().add(@dateLimit).isAfter(maxDate)
          maxDate = start.clone().add(@dateLimit)
        if maxDate and end.isAfter(maxDate)
          end = maxDate.clone()
        # If the end of the range is before the minimum or the start of the range is
        # after the maximum, don't display this range option at all.
        if @minDate and end.isBefore(@minDate, (if @timepicker then 'minute' else 'day')) or maxDate and start.isAfter(maxDate, (if @timepicker then 'minute' else 'day'))
          continue
        #Support unicode chars in the range names.
        elem = document.createElement('textarea')
        elem.innerHTML = range
        rangeHtml = elem.value
        @ranges[rangeHtml] = [
          start
          end
        ]
      list = '<ul>'
      for range of @ranges
        `range = range`
        list += '<li data-range-key="' + range + '">' + range + '</li>'
      if @showCustomRangeLabel
        list += '<li data-range-key="' + @locale.customRangeLabel + '">' + @locale.customRangeLabel + '</li>'
      list += '</ul>'
      @container.find('.ranges').prepend list
    if typeof cb == 'function'
      @callback = cb
    if !@timePicker
      @startDate = @startDate.startOf('day')
      @endDate = @endDate.endOf('day')
      @container.find('.calendar-time').hide()
    #can't be used together for now
    if @timePicker and @autoApply
      @autoApply = false
    if @autoApply and typeof options.ranges != 'object'
      @container.find('.ranges').hide()
    else if @autoApply
      @container.find('.applyBtn, .cancelBtn').addClass 'hide'
    if @singleDatePicker
      @container.addClass 'single'
      @container.find('.calendar.left').addClass 'single'
      @container.find('.calendar.left').show()
      @container.find('.calendar.right').hide()
      @container.find('.daterangepicker_input input, .daterangepicker_input > i').hide()
      if @timePicker
        @container.find('.ranges ul').hide()
      else
        @container.find('.ranges').hide()
    if typeof options.ranges == 'undefined' and !@singleDatePicker or @alwaysShowCalendars
      @container.addClass 'show-calendar'
    @container.addClass 'opens' + @opens
    #swap the position of the predefined ranges if opens right
    if typeof options.ranges != 'undefined' and @opens == 'right'
      @container.find('.ranges').prependTo @container.find('.calendar.left').parent()
    #apply CSS classes and labels to buttons
    @container.find('.applyBtn, .cancelBtn').addClass @buttonClasses
    if @applyClass.length
      @container.find('.applyBtn').addClass @applyClass
    if @cancelClass.length
      @container.find('.cancelBtn').addClass @cancelClass
    @container.find('.applyBtn').html @locale.applyLabel
    @container.find('.cancelBtn').html @locale.cancelLabel
    #
    # event listeners
    #
    @container.find('.calendar').on('click.daterangepicker', '.prev', $.proxy(@clickPrev, this)).on('click.daterangepicker', '.next', $.proxy(@clickNext, this)).on('mousedown.daterangepicker', 'td.available', $.proxy(@clickDate, this)).on('mouseenter.daterangepicker', 'td.available', $.proxy(@hoverDate, this)).on('mouseleave.daterangepicker', 'td.available', $.proxy(@updateFormInputs, this)).on('change.daterangepicker', 'select.yearselect', $.proxy(@monthOrYearChanged, this)).on('change.daterangepicker', 'select.monthselect', $.proxy(@monthOrYearChanged, this)).on('change.daterangepicker', 'select.hourselect,select.minuteselect,select.secondselect,select.ampmselect', $.proxy(@timeChanged, this)).on('click.daterangepicker', '.daterangepicker_input input', $.proxy(@showCalendars, this)).on('focus.daterangepicker', '.daterangepicker_input input', $.proxy(@formInputsFocused, this)).on('blur.daterangepicker', '.daterangepicker_input input', $.proxy(@formInputsBlurred, this)).on 'change.daterangepicker', '.daterangepicker_input input', $.proxy(@formInputsChanged, this)
    @container.find('.ranges').on('click.daterangepicker', 'button.applyBtn', $.proxy(@clickApply, this)).on('click.daterangepicker', 'button.cancelBtn', $.proxy(@clickCancel, this)).on('click.daterangepicker', 'li', $.proxy(@clickRange, this)).on('mouseenter.daterangepicker', 'li', $.proxy(@hoverRange, this)).on 'mouseleave.daterangepicker', 'li', $.proxy(@updateFormInputs, this)
    if @element.is('input') or @element.is('button')
      @element.on
        'click.daterangepicker': $.proxy(@show, this)
        'focus.daterangepicker': $.proxy(@show, this)
        'keyup.daterangepicker': $.proxy(@elementChanged, this)
        'keydown.daterangepicker': $.proxy(@keydown, this)
    else
      @element.on 'click.daterangepicker', $.proxy(@toggle, this)
    #
    # if attached to a text input, set the initial value
    #
    if @element.is('input') and !@singleDatePicker and @autoUpdateInput
      @element.val @startDate.format(@locale.format) + @locale.separator + @endDate.format(@locale.format)
      @element.trigger 'change'
    else if @element.is('input') and @autoUpdateInput
      @element.val @startDate.format(@locale.format)
      @element.trigger 'change'
    return

  DateRangePicker.prototype =
    constructor: DateRangePicker
    setStartDate: (startDate) ->
      if typeof startDate == 'string'
        @startDate = moment(startDate, @locale.format)
      if typeof startDate == 'object'
        @startDate = moment(startDate)
      if !@timePicker
        @startDate = @startDate.startOf('day')
      if @timePicker and @timePickerIncrement
        @startDate.minute Math.round(@startDate.minute() / @timePickerIncrement) * @timePickerIncrement
      if @minDate and @startDate.isBefore(@minDate)
        @startDate = @minDate.clone()
        if @timePicker and @timePickerIncrement
          @startDate.minute Math.round(@startDate.minute() / @timePickerIncrement) * @timePickerIncrement
      if @maxDate and @startDate.isAfter(@maxDate)
        @startDate = @maxDate.clone()
        if @timePicker and @timePickerIncrement
          @startDate.minute Math.floor(@startDate.minute() / @timePickerIncrement) * @timePickerIncrement
      if !@isShowing
        @updateElement()
      @updateMonthsInView()
      return
    setEndDate: (endDate) ->
      if typeof endDate == 'string'
        @endDate = moment(endDate, @locale.format)
      if typeof endDate == 'object'
        @endDate = moment(endDate)
      if !@timePicker
        @endDate = @endDate.endOf('day')
      if @timePicker and @timePickerIncrement
        @endDate.minute Math.round(@endDate.minute() / @timePickerIncrement) * @timePickerIncrement
      if @endDate.isBefore(@startDate)
        @endDate = @startDate.clone()
      if @maxDate and @endDate.isAfter(@maxDate)
        @endDate = @maxDate.clone()
      if @dateLimit and @startDate.clone().add(@dateLimit).isBefore(@endDate)
        @endDate = @startDate.clone().add(@dateLimit)
      @previousRightTime = @endDate.clone()
      if !@isShowing
        @updateElement()
      @updateMonthsInView()
      return
    isInvalidDate: ->
      false
    isCustomDate: ->
      false
    updateView: ->
      if @timePicker
        @renderTimePicker 'left'
        @renderTimePicker 'right'
        if !@endDate
          @container.find('.right .calendar-time select').attr('disabled', 'disabled').addClass 'disabled'
        else
          @container.find('.right .calendar-time select').removeAttr('disabled').removeClass 'disabled'
      if @endDate
        @container.find('input[name="daterangepicker_end"]').removeClass 'active'
        @container.find('input[name="daterangepicker_start"]').addClass 'active'
      else
        @container.find('input[name="daterangepicker_end"]').addClass 'active'
        @container.find('input[name="daterangepicker_start"]').removeClass 'active'
      @updateMonthsInView()
      @updateCalendars()
      @updateFormInputs()
      return
    updateMonthsInView: ->
      if @endDate
        #if both dates are visible already, do nothing
        if !@singleDatePicker and @leftCalendar.month and @rightCalendar.month and (@startDate.format('YYYY-MM') == @leftCalendar.month.format('YYYY-MM') or @startDate.format('YYYY-MM') == @rightCalendar.month.format('YYYY-MM')) and (@endDate.format('YYYY-MM') == @leftCalendar.month.format('YYYY-MM') or @endDate.format('YYYY-MM') == @rightCalendar.month.format('YYYY-MM'))
          return
        @leftCalendar.month = @startDate.clone().date(2)
        if !@linkedCalendars and (@endDate.month() != @startDate.month() or @endDate.year() != @startDate.year())
          @rightCalendar.month = @endDate.clone().date(2)
        else
          @rightCalendar.month = @startDate.clone().date(2).add(1, 'month')
      else
        if @leftCalendar.month.format('YYYY-MM') != @startDate.format('YYYY-MM') and @rightCalendar.month.format('YYYY-MM') != @startDate.format('YYYY-MM')
          @leftCalendar.month = @startDate.clone().date(2)
          @rightCalendar.month = @startDate.clone().date(2).add(1, 'month')
      if @maxDate and @linkedCalendars and !@singleDatePicker and @rightCalendar.month > @maxDate
        @rightCalendar.month = @maxDate.clone().date(2)
        @leftCalendar.month = @maxDate.clone().date(2).subtract(1, 'month')
      return
    updateCalendars: ->
      `var ampm`
      if @timePicker
        hour = undefined
        minute = undefined
        second = undefined
        if @endDate
          hour = parseInt(@container.find('.left .hourselect').val(), 10)
          minute = parseInt(@container.find('.left .minuteselect').val(), 10)
          second = if @timePickerSeconds then parseInt(@container.find('.left .secondselect').val(), 10) else 0
          if !@timePicker24Hour
            ampm = @container.find('.left .ampmselect').val()
            if ampm == 'PM' and hour < 12
              hour += 12
            if ampm == 'AM' and hour == 12
              hour = 0
        else
          hour = parseInt(@container.find('.right .hourselect').val(), 10)
          minute = parseInt(@container.find('.right .minuteselect').val(), 10)
          second = if @timePickerSeconds then parseInt(@container.find('.right .secondselect').val(), 10) else 0
          if !@timePicker24Hour
            ampm = @container.find('.right .ampmselect').val()
            if ampm == 'PM' and hour < 12
              hour += 12
            if ampm == 'AM' and hour == 12
              hour = 0
        @leftCalendar.month.hour(hour).minute(minute).second second
        @rightCalendar.month.hour(hour).minute(minute).second second
      @renderCalendar 'left'
      @renderCalendar 'right'
      #highlight any predefined range matching the current start and end dates
      @container.find('.ranges li').removeClass 'active'
      if @endDate == null
        return
      @calculateChosenLabel()
      return
    renderCalendar: (side) ->
      `var calendar`
      `var i`
      `var col`
      `var row`
      `var row`
      `var col`
      `var i`
      #
      # Build the matrix of dates that will populate the calendar
      #
      calendar = if side == 'left' then @leftCalendar else @rightCalendar
      month = calendar.month.month()
      year = calendar.month.year()
      hour = calendar.month.hour()
      minute = calendar.month.minute()
      second = calendar.month.second()
      daysInMonth = moment([
        year
        month
      ]).daysInMonth()
      firstDay = moment([
        year
        month
        1
      ])
      lastDay = moment([
        year
        month
        daysInMonth
      ])
      lastMonth = moment(firstDay).subtract(1, 'month').month()
      lastYear = moment(firstDay).subtract(1, 'month').year()
      daysInLastMonth = moment([
        lastYear
        lastMonth
      ]).daysInMonth()
      dayOfWeek = firstDay.day()
      #initialize a 6 rows x 7 columns array for the calendar
      calendar = []
      calendar.firstDay = firstDay
      calendar.lastDay = lastDay
      i = 0
      while i < 6
        calendar[i] = []
        i++
      #populate the calendar with date objects
      startDay = daysInLastMonth - dayOfWeek + @locale.firstDay + 1
      if startDay > daysInLastMonth
        startDay -= 7
      if dayOfWeek == @locale.firstDay
        startDay = daysInLastMonth - 6
      curDate = moment([
        lastYear
        lastMonth
        startDay
        12
        minute
        second
      ])
      col = undefined
      row = undefined
      i = 0
      col = 0
      row = 0
      while i < 42
        if i > 0 and col % 7 == 0
          col = 0
          row++
        calendar[row][col] = curDate.clone().hour(hour).minute(minute).second(second)
        curDate.hour 12
        if @minDate and calendar[row][col].format('YYYY-MM-DD') == @minDate.format('YYYY-MM-DD') and calendar[row][col].isBefore(@minDate) and side == 'left'
          calendar[row][col] = @minDate.clone()
        if @maxDate and calendar[row][col].format('YYYY-MM-DD') == @maxDate.format('YYYY-MM-DD') and calendar[row][col].isAfter(@maxDate) and side == 'right'
          calendar[row][col] = @maxDate.clone()
        i++
        col++
        curDate = moment(curDate).add(24, 'hour')
      #make the calendar object available to hoverDate/clickDate
      if side == 'left'
        @leftCalendar.calendar = calendar
      else
        @rightCalendar.calendar = calendar
      #
      # Display the calendar
      #
      minDate = if side == 'left' then @minDate else @startDate
      maxDate = @maxDate
      selected = if side == 'left' then @startDate else @endDate
      arrow = if @locale.direction == 'ltr' then
        left: 'chevron-left'
        right: 'chevron-right' else
        left: 'chevron-right'
        right: 'chevron-left'
      html = '<table class="table-condensed">'
      html += '<thead>'
      html += '<tr>'
      # add empty cell for week number
      if @showWeekNumbers or @showISOWeekNumbers
        html += '<th></th>'
      if (!minDate or minDate.isBefore(calendar.firstDay)) and (!@linkedCalendars or side == 'left')
        html += '<th class="prev available"><i class="fa fa-' + arrow.left + ' glyphicon glyphicon-' + arrow.left + '"></i></th>'
      else
        html += '<th></th>'
      dateHtml = @locale.monthNames[calendar[1][1].month()] + calendar[1][1].format(' YYYY')
      if @showDropdowns
        currentMonth = calendar[1][1].month()
        currentYear = calendar[1][1].year()
        maxYear = maxDate and maxDate.year() or currentYear + 5
        minYear = minDate and minDate.year() or currentYear - 50
        inMinYear = currentYear == minYear
        inMaxYear = currentYear == maxYear
        monthHtml = '<select class="monthselect">'
        m = 0
        while m < 12
          if (!inMinYear or m >= minDate.month()) and (!inMaxYear or m <= maxDate.month())
            monthHtml += '<option value=\'' + m + '\'' + (if m == currentMonth then ' selected=\'selected\'' else '') + '>' + @locale.monthNames[m] + '</option>'
          else
            monthHtml += '<option value=\'' + m + '\'' + (if m == currentMonth then ' selected=\'selected\'' else '') + ' disabled=\'disabled\'>' + @locale.monthNames[m] + '</option>'
          m++
        monthHtml += '</select>'
        yearHtml = '<select class="yearselect">'
        y = minYear
        while y <= maxYear
          yearHtml += '<option value="' + y + '"' + (if y == currentYear then ' selected="selected"' else '') + '>' + y + '</option>'
          y++
        yearHtml += '</select>'
        dateHtml = monthHtml + yearHtml
      html += '<th colspan="5" class="month">' + dateHtml + '</th>'
      if (!maxDate or maxDate.isAfter(calendar.lastDay)) and (!@linkedCalendars or side == 'right' or @singleDatePicker)
        html += '<th class="next available"><i class="fa fa-' + arrow.right + ' glyphicon glyphicon-' + arrow.right + '"></i></th>'
      else
        html += '<th></th>'
      html += '</tr>'
      html += '<tr>'
      # add week number label
      if @showWeekNumbers or @showISOWeekNumbers
        html += '<th class="week">' + @locale.weekLabel + '</th>'
      $.each @locale.daysOfWeek, (index, dayOfWeek) ->
        html += '<th>' + dayOfWeek + '</th>'
        return
      html += '</tr>'
      html += '</thead>'
      html += '<tbody>'
      #adjust maxDate to reflect the dateLimit setting in order to
      #grey out end dates beyond the dateLimit
      if @endDate == null and @dateLimit
        maxLimit = @startDate.clone().add(@dateLimit).endOf('day')
        if !maxDate or maxLimit.isBefore(maxDate)
          maxDate = maxLimit
      row = 0
      while row < 6
        html += '<tr>'
        # add week number
        if @showWeekNumbers
          html += '<td class="week">' + calendar[row][0].week() + '</td>'
        else if @showISOWeekNumbers
          html += '<td class="week">' + calendar[row][0].isoWeek() + '</td>'
        col = 0
        while col < 7
          classes = []
          #highlight today's date
          if calendar[row][col].isSame(new Date, 'day')
            classes.push 'today'
          #highlight weekends
          if calendar[row][col].isoWeekday() > 5
            classes.push 'weekend'
          #grey out the dates in other months displayed at beginning and end of this calendar
          if calendar[row][col].month() != calendar[1][1].month()
            classes.push 'off'
          #don't allow selection of dates before the minimum date
          if @minDate and calendar[row][col].isBefore(@minDate, 'day')
            classes.push 'off', 'disabled'
          #don't allow selection of dates after the maximum date
          if maxDate and calendar[row][col].isAfter(maxDate, 'day')
            classes.push 'off', 'disabled'
          #don't allow selection of date if a custom function decides it's invalid
          if @isInvalidDate(calendar[row][col])
            classes.push 'off', 'disabled'
          #highlight the currently selected start date
          if calendar[row][col].format('YYYY-MM-DD') == @startDate.format('YYYY-MM-DD')
            classes.push 'active', 'start-date'
          #highlight the currently selected end date
          if @endDate != null and calendar[row][col].format('YYYY-MM-DD') == @endDate.format('YYYY-MM-DD')
            classes.push 'active', 'end-date'
          #highlight dates in-between the selected dates
          if @endDate != null and calendar[row][col] > @startDate and calendar[row][col] < @endDate
            classes.push 'in-range'
          #apply custom classes for this date
          isCustom = @isCustomDate(calendar[row][col])
          if isCustom != false
            if typeof isCustom == 'string'
              classes.push isCustom
            else
              Array::push.apply classes, isCustom
          cname = ''
          disabled = false
          i = 0
          while i < classes.length
            cname += classes[i] + ' '
            if classes[i] == 'disabled'
              disabled = true
            i++
          if !disabled
            cname += 'available'
          html += '<td class="' + cname.replace(/^\s+|\s+$/g, '') + '" data-title="' + 'r' + row + 'c' + col + '">' + calendar[row][col].date() + '</td>'
          col++
        html += '</tr>'
        row++
      html += '</tbody>'
      html += '</table>'
      @container.find('.calendar.' + side + ' .calendar-table').html html
      return
    renderTimePicker: (side) ->
      `var i`
      `var time`
      `var disabled`
      `var i`
      `var padded`
      `var time`
      `var disabled`
      # Don't bother updating the time picker if it's currently disabled
      # because an end date hasn't been clicked yet
      if side == 'right' and !@endDate
        return
      html = undefined
      selected = undefined
      minDate = undefined
      maxDate = @maxDate
      if @dateLimit and (!@maxDate or @startDate.clone().add(@dateLimit).isAfter(@maxDate))
        maxDate = @startDate.clone().add(@dateLimit)
      if side == 'left'
        selected = @startDate.clone()
        minDate = @minDate
      else if side == 'right'
        selected = @endDate.clone()
        minDate = @startDate
        #Preserve the time already selected
        timeSelector = @container.find('.calendar.right .calendar-time div')
        if timeSelector.html() != ''
          selected.hour timeSelector.find('.hourselect option:selected').val() or selected.hour()
          selected.minute timeSelector.find('.minuteselect option:selected').val() or selected.minute()
          selected.second timeSelector.find('.secondselect option:selected').val() or selected.second()
          if !@timePicker24Hour
            ampm = timeSelector.find('.ampmselect option:selected').val()
            if ampm == 'PM' and selected.hour() < 12
              selected.hour selected.hour() + 12
            if ampm == 'AM' and selected.hour() == 12
              selected.hour 0
        if selected.isBefore(@startDate)
          selected = @startDate.clone()
        if maxDate and selected.isAfter(maxDate)
          selected = maxDate.clone()
      #
      # hours
      #
      html = '<select class="hourselect">'
      start = if @timePicker24Hour then 0 else 1
      end = if @timePicker24Hour then 23 else 12
      i = start
      while i <= end
        i_in_24 = i
        if !@timePicker24Hour
          i_in_24 = if selected.hour() >= 12 then (if i == 12 then 12 else i + 12) else if i == 12 then 0 else i
        time = selected.clone().hour(i_in_24)
        disabled = false
        if minDate and time.minute(59).isBefore(minDate)
          disabled = true
        if maxDate and time.minute(0).isAfter(maxDate)
          disabled = true
        if i_in_24 == selected.hour() and !disabled
          html += '<option value="' + i + '" selected="selected">' + i + '</option>'
        else if disabled
          html += '<option value="' + i + '" disabled="disabled" class="disabled">' + i + '</option>'
        else
          html += '<option value="' + i + '">' + i + '</option>'
        i++
      html += '</select> '
      #
      # minutes
      #
      html += ': <select class="minuteselect">'
      i = 0
      while i < 60
        padded = if i < 10 then '0' + i else i
        time = selected.clone().minute(i)
        disabled = false
        if minDate and time.second(59).isBefore(minDate)
          disabled = true
        if maxDate and time.second(0).isAfter(maxDate)
          disabled = true
        if selected.minute() == i and !disabled
          html += '<option value="' + i + '" selected="selected">' + padded + '</option>'
        else if disabled
          html += '<option value="' + i + '" disabled="disabled" class="disabled">' + padded + '</option>'
        else
          html += '<option value="' + i + '">' + padded + '</option>'
        i += @timePickerIncrement
      html += '</select> '
      #
      # seconds
      #
      if @timePickerSeconds
        html += ': <select class="secondselect">'
        i = 0
        while i < 60
          padded = if i < 10 then '0' + i else i
          time = selected.clone().second(i)
          disabled = false
          if minDate and time.isBefore(minDate)
            disabled = true
          if maxDate and time.isAfter(maxDate)
            disabled = true
          if selected.second() == i and !disabled
            html += '<option value="' + i + '" selected="selected">' + padded + '</option>'
          else if disabled
            html += '<option value="' + i + '" disabled="disabled" class="disabled">' + padded + '</option>'
          else
            html += '<option value="' + i + '">' + padded + '</option>'
          i++
        html += '</select> '
      #
      # AM/PM
      #
      if !@timePicker24Hour
        html += '<select class="ampmselect">'
        am_html = ''
        pm_html = ''
        if minDate and selected.clone().hour(12).minute(0).second(0).isBefore(minDate)
          am_html = ' disabled="disabled" class="disabled"'
        if maxDate and selected.clone().hour(0).minute(0).second(0).isAfter(maxDate)
          pm_html = ' disabled="disabled" class="disabled"'
        if selected.hour() >= 12
          html += '<option value="AM"' + am_html + '>AM</option><option value="PM" selected="selected"' + pm_html + '>PM</option>'
        else
          html += '<option value="AM" selected="selected"' + am_html + '>AM</option><option value="PM"' + pm_html + '>PM</option>'
        html += '</select>'
      @container.find('.calendar.' + side + ' .calendar-time div').html html
      return
    updateFormInputs: ->
      #ignore mouse movements while an above-calendar text input has focus
      if @container.find('input[name=daterangepicker_start]').is(':focus') or @container.find('input[name=daterangepicker_end]').is(':focus')
        return
      @container.find('input[name=daterangepicker_start]').val @startDate.format(@locale.format)
      if @endDate
        @container.find('input[name=daterangepicker_end]').val @endDate.format(@locale.format)
      if @singleDatePicker or @endDate and (@startDate.isBefore(@endDate) or @startDate.isSame(@endDate))
        @container.find('button.applyBtn').removeAttr 'disabled'
      else
        @container.find('button.applyBtn').attr 'disabled', 'disabled'
      return
    move: ->
      parentOffset = 
        top: 0
        left: 0
      containerTop = undefined
      parentRightEdge = $(window).width()
      if !@parentEl.is('body')
        parentOffset =
          top: @parentEl.offset().top - @parentEl.scrollTop()
          left: @parentEl.offset().left - @parentEl.scrollLeft()
        parentRightEdge = @parentEl[0].clientWidth + @parentEl.offset().left
      if @drops == 'up'
        containerTop = @element.offset().top - @container.outerHeight() - (parentOffset.top)
      else
        containerTop = @element.offset().top + @element.outerHeight() - (parentOffset.top)
      @container[if @drops == 'up' then 'addClass' else 'removeClass'] 'dropup'
      if @opens == 'left'
        @container.css
          top: containerTop
          right: parentRightEdge - (@element.offset().left) - @element.outerWidth()
          left: 'auto'
        if @container.offset().left < 0
          @container.css
            right: 'auto'
            left: 9
      else if @opens == 'center'
        @container.css
          top: containerTop
          left: @element.offset().left - (parentOffset.left) + @element.outerWidth() / 2 - (@container.outerWidth() / 2)
          right: 'auto'
        if @container.offset().left < 0
          @container.css
            right: 'auto'
            left: 9
      else
        @container.css
          top: containerTop
          left: @element.offset().left - (parentOffset.left)
          right: 'auto'
        if @container.offset().left + @container.outerWidth() > $(window).width()
          @container.css
            left: 'auto'
            right: 0
      return
    show: (e) ->
      if @isShowing
        return
      # Create a click proxy that is private to this instance of datepicker, for unbinding
      @_outsideClickProxy = $.proxy(((e) ->
        @outsideClick e
        return
      ), this)
      # Bind global datepicker mousedown for hiding and
      $(document).on('mousedown.daterangepicker', @_outsideClickProxy).on('touchend.daterangepicker', @_outsideClickProxy).on('click.daterangepicker', '[data-toggle=dropdown]', @_outsideClickProxy).on 'focusin.daterangepicker', @_outsideClickProxy
      # Reposition the picker if the window is resized while it's open
      $(window).on 'resize.daterangepicker', $.proxy(((e) ->
        @move e
        return
      ), this)
      @oldStartDate = @startDate.clone()
      @oldEndDate = @endDate.clone()
      @previousRightTime = @endDate.clone()
      @updateView()
      @container.show()
      @move()
      @element.trigger 'show.daterangepicker', this
      @isShowing = true
      return
    hide: (e) ->
      if !@isShowing
        return
      #incomplete date selection, revert to last values
      if !@endDate
        @startDate = @oldStartDate.clone()
        @endDate = @oldEndDate.clone()
      #if a new date range was selected, invoke the user callback function
      if !@startDate.isSame(@oldStartDate) or !@endDate.isSame(@oldEndDate)
        @callback @startDate, @endDate, @chosenLabel
      #if picker is attached to a text input, update it
      @updateElement()
      $(document).off '.daterangepicker'
      $(window).off '.daterangepicker'
      @container.hide()
      @element.trigger 'hide.daterangepicker', this
      @isShowing = false
      return
    toggle: (e) ->
      if @isShowing
        @hide()
      else
        @show()
      return
    outsideClick: (e) ->
      target = $(e.target)
      # if the page is clicked anywhere except within the daterangerpicker/button
      # itself then call this.hide()
      if e.type == 'focusin' or target.closest(@element).length or target.closest(@container).length or target.closest('.calendar-table').length
        return
      @hide()
      @element.trigger 'outsideClick.daterangepicker', this
      return
    showCalendars: ->
      @container.addClass 'show-calendar'
      @move()
      @element.trigger 'showCalendar.daterangepicker', this
      return
    hideCalendars: ->
      @container.removeClass 'show-calendar'
      @element.trigger 'hideCalendar.daterangepicker', this
      return
    hoverRange: (e) ->
      #ignore mouse movements while an above-calendar text input has focus
      if @container.find('input[name=daterangepicker_start]').is(':focus') or @container.find('input[name=daterangepicker_end]').is(':focus')
        return
      label = e.target.getAttribute('data-range-key')
      if label == @locale.customRangeLabel
        @updateView()
      else
        dates = @ranges[label]
        @container.find('input[name=daterangepicker_start]').val dates[0].format(@locale.format)
        @container.find('input[name=daterangepicker_end]').val dates[1].format(@locale.format)
      return
    clickRange: (e) ->
      label = e.target.getAttribute('data-range-key')
      @chosenLabel = label
      if label == @locale.customRangeLabel
        @showCalendars()
      else
        dates = @ranges[label]
        @startDate = dates[0]
        @endDate = dates[1]
        if !@timePicker
          @startDate.startOf 'day'
          @endDate.endOf 'day'
        if !@alwaysShowCalendars
          @hideCalendars()
        @clickApply()
      return
    clickPrev: (e) ->
      cal = $(e.target).parents('.calendar')
      if cal.hasClass('left')
        @leftCalendar.month.subtract 1, 'month'
        if @linkedCalendars
          @rightCalendar.month.subtract 1, 'month'
      else
        @rightCalendar.month.subtract 1, 'month'
      @updateCalendars()
      return
    clickNext: (e) ->
      cal = $(e.target).parents('.calendar')
      if cal.hasClass('left')
        @leftCalendar.month.add 1, 'month'
      else
        @rightCalendar.month.add 1, 'month'
        if @linkedCalendars
          @leftCalendar.month.add 1, 'month'
      @updateCalendars()
      return
    hoverDate: (e) ->
      #ignore mouse movements while an above-calendar text input has focus
      #if (this.container.find('input[name=daterangepicker_start]').is(":focus") || this.container.find('input[name=daterangepicker_end]').is(":focus"))
      #    return;
      #ignore dates that can't be selected
      if !$(e.target).hasClass('available')
        return
      #have the text inputs above calendars reflect the date being hovered over
      title = $(e.target).attr('data-title')
      row = title.substr(1, 1)
      col = title.substr(3, 1)
      cal = $(e.target).parents('.calendar')
      date = if cal.hasClass('left') then @leftCalendar.calendar[row][col] else @rightCalendar.calendar[row][col]
      if @endDate and !@container.find('input[name=daterangepicker_start]').is(':focus')
        @container.find('input[name=daterangepicker_start]').val date.format(@locale.format)
      else if !@endDate and !@container.find('input[name=daterangepicker_end]').is(':focus')
        @container.find('input[name=daterangepicker_end]').val date.format(@locale.format)
      #highlight the dates between the start date and the date being hovered as a potential end date
      leftCalendar = @leftCalendar
      rightCalendar = @rightCalendar
      startDate = @startDate
      if !@endDate
        @container.find('.calendar tbody td').each (index, el) ->
          `var title`
          `var row`
          `var col`
          `var cal`
          #skip week numbers, only look at dates
          if $(el).hasClass('week')
            return
          title = $(el).attr('data-title')
          row = title.substr(1, 1)
          col = title.substr(3, 1)
          cal = $(el).parents('.calendar')
          dt = if cal.hasClass('left') then leftCalendar.calendar[row][col] else rightCalendar.calendar[row][col]
          if dt.isAfter(startDate) and dt.isBefore(date) or dt.isSame(date, 'day')
            $(el).addClass 'in-range'
          else
            $(el).removeClass 'in-range'
          return
      return
    clickDate: (e) ->
      `var hour`
      `var ampm`
      `var minute`
      `var second`
      if !$(e.target).hasClass('available')
        return
      title = $(e.target).attr('data-title')
      row = title.substr(1, 1)
      col = title.substr(3, 1)
      cal = $(e.target).parents('.calendar')
      date = if cal.hasClass('left') then @leftCalendar.calendar[row][col] else @rightCalendar.calendar[row][col]
      #
      # this function needs to do a few things:
      # * alternate between selecting a start and end date for the range,
      # * if the time picker is enabled, apply the hour/minute/second from the select boxes to the clicked date
      # * if autoapply is enabled, and an end date was chosen, apply the selection
      # * if single date picker mode, and time picker isn't enabled, apply the selection immediately
      # * if one of the inputs above the calendars was focused, cancel that manual input
      #
      if @endDate or date.isBefore(@startDate, 'day')
        #picking start
        if @timePicker
          hour = parseInt(@container.find('.left .hourselect').val(), 10)
          if !@timePicker24Hour
            ampm = @container.find('.left .ampmselect').val()
            if ampm == 'PM' and hour < 12
              hour += 12
            if ampm == 'AM' and hour == 12
              hour = 0
          minute = parseInt(@container.find('.left .minuteselect').val(), 10)
          second = if @timePickerSeconds then parseInt(@container.find('.left .secondselect').val(), 10) else 0
          date = date.clone().hour(hour).minute(minute).second(second)
        @endDate = null
        @setStartDate date.clone()
      else if !@endDate and date.isBefore(@startDate)
        #special case: clicking the same date for start/end,
        #but the time of the end date is before the start date
        @setEndDate @startDate.clone()
      else
        # picking end
        if @timePicker
          hour = parseInt(@container.find('.right .hourselect').val(), 10)
          if !@timePicker24Hour
            ampm = @container.find('.right .ampmselect').val()
            if ampm == 'PM' and hour < 12
              hour += 12
            if ampm == 'AM' and hour == 12
              hour = 0
          minute = parseInt(@container.find('.right .minuteselect').val(), 10)
          second = if @timePickerSeconds then parseInt(@container.find('.right .secondselect').val(), 10) else 0
          date = date.clone().hour(hour).minute(minute).second(second)
        @setEndDate date.clone()
        if @autoApply
          @calculateChosenLabel()
          @clickApply()
      if @singleDatePicker
        @setEndDate @startDate
        if !@timePicker
          @clickApply()
      @updateView()
      #This is to cancel the blur event handler if the mouse was in one of the inputs
      e.stopPropagation()
      return
    calculateChosenLabel: ->
      customRange = true
      i = 0
      for range of @ranges
        if @timePicker
          if @startDate.isSame(@ranges[range][0]) and @endDate.isSame(@ranges[range][1])
            customRange = false
            @chosenLabel = @container.find('.ranges li:eq(' + i + ')').addClass('active').html()
            break
        else
          #ignore times when comparing dates if time picker is not enabled
          if @startDate.format('YYYY-MM-DD') == @ranges[range][0].format('YYYY-MM-DD') and @endDate.format('YYYY-MM-DD') == @ranges[range][1].format('YYYY-MM-DD')
            customRange = false
            @chosenLabel = @container.find('.ranges li:eq(' + i + ')').addClass('active').html()
            break
        i++
      if customRange
        if @showCustomRangeLabel
          @chosenLabel = @container.find('.ranges li:last').addClass('active').html()
        else
          @chosenLabel = null
        @showCalendars()
      return
    clickApply: (e) ->
      @hide()
      @element.trigger 'apply.daterangepicker', this
      return
    clickCancel: (e) ->
      @startDate = @oldStartDate
      @endDate = @oldEndDate
      @hide()
      @element.trigger 'cancel.daterangepicker', this
      return
    monthOrYearChanged: (e) ->
      isLeft = $(e.target).closest('.calendar').hasClass('left')
      leftOrRight = if isLeft then 'left' else 'right'
      cal = @container.find('.calendar.' + leftOrRight)
      # Month must be Number for new moment versions
      month = parseInt(cal.find('.monthselect').val(), 10)
      year = cal.find('.yearselect').val()
      if !isLeft
        if year < @startDate.year() or year == @startDate.year() and month < @startDate.month()
          month = @startDate.month()
          year = @startDate.year()
      if @minDate
        if year < @minDate.year() or year == @minDate.year() and month < @minDate.month()
          month = @minDate.month()
          year = @minDate.year()
      if @maxDate
        if year > @maxDate.year() or year == @maxDate.year() and month > @maxDate.month()
          month = @maxDate.month()
          year = @maxDate.year()
      if isLeft
        @leftCalendar.month.month(month).year year
        if @linkedCalendars
          @rightCalendar.month = @leftCalendar.month.clone().add(1, 'month')
      else
        @rightCalendar.month.month(month).year year
        if @linkedCalendars
          @leftCalendar.month = @rightCalendar.month.clone().subtract(1, 'month')
      @updateCalendars()
      return
    timeChanged: (e) ->
      cal = $(e.target).closest('.calendar')
      isLeft = cal.hasClass('left')
      hour = parseInt(cal.find('.hourselect').val(), 10)
      minute = parseInt(cal.find('.minuteselect').val(), 10)
      second = if @timePickerSeconds then parseInt(cal.find('.secondselect').val(), 10) else 0
      if !@timePicker24Hour
        ampm = cal.find('.ampmselect').val()
        if ampm == 'PM' and hour < 12
          hour += 12
        if ampm == 'AM' and hour == 12
          hour = 0
      if isLeft
        start = @startDate.clone()
        start.hour hour
        start.minute minute
        start.second second
        @setStartDate start
        if @singleDatePicker
          @endDate = @startDate.clone()
        else if @endDate and @endDate.format('YYYY-MM-DD') == start.format('YYYY-MM-DD') and @endDate.isBefore(start)
          @setEndDate start.clone()
      else if @endDate
        end = @endDate.clone()
        end.hour hour
        end.minute minute
        end.second second
        @setEndDate end
      #update the calendars so all clickable dates reflect the new time component
      @updateCalendars()
      #update the form inputs above the calendars with the new time
      @updateFormInputs()
      #re-render the time pickers because changing one selection can affect what's enabled in another
      @renderTimePicker 'left'
      @renderTimePicker 'right'
      return
    formInputsChanged: (e) ->
      isRight = $(e.target).closest('.calendar').hasClass('right')
      start = moment(@container.find('input[name="daterangepicker_start"]').val(), @locale.format)
      end = moment(@container.find('input[name="daterangepicker_end"]').val(), @locale.format)
      if start.isValid() and end.isValid()
        if isRight and end.isBefore(start)
          start = end.clone()
        @setStartDate start
        @setEndDate end
        if isRight
          @container.find('input[name="daterangepicker_start"]').val @startDate.format(@locale.format)
        else
          @container.find('input[name="daterangepicker_end"]').val @endDate.format(@locale.format)
      @updateView()
      return
    formInputsFocused: (e) ->
      # Highlight the focused input
      @container.find('input[name="daterangepicker_start"], input[name="daterangepicker_end"]').removeClass 'active'
      $(e.target).addClass 'active'
      # Set the state such that if the user goes back to using a mouse, 
      # the calendars are aware we're selecting the end of the range, not
      # the start. This allows someone to edit the end of a date range without
      # re-selecting the beginning, by clicking on the end date input then
      # using the calendar.
      isRight = $(e.target).closest('.calendar').hasClass('right')
      if isRight
        @endDate = null
        @setStartDate @startDate.clone()
        @updateView()
      return
    formInputsBlurred: (e) ->
      # this function has one purpose right now: if you tab from the first
      # text input to the second in the UI, the endDate is nulled so that
      # you can click another, but if you tab out without clicking anything
      # or changing the input value, the old endDate should be retained
      if !@endDate
        val = @container.find('input[name="daterangepicker_end"]').val()
        end = moment(val, @locale.format)
        if end.isValid()
          @setEndDate end
          @updateView()
      return
    elementChanged: ->
      if !@element.is('input')
        return
      if !@element.val().length
        return
      if @element.val().length < @locale.format.length
        return
      dateString = @element.val().split(@locale.separator)
      start = null
      end = null
      if dateString.length == 2
        start = moment(dateString[0], @locale.format)
        end = moment(dateString[1], @locale.format)
      if @singleDatePicker or start == null or end == null
        start = moment(@element.val(), @locale.format)
        end = start
      if !start.isValid() or !end.isValid()
        return
      @setStartDate start
      @setEndDate end
      @updateView()
      return
    keydown: (e) ->
      #hide on tab or enter
      if e.keyCode == 9 or e.keyCode == 13
        @hide()
      return
    updateElement: ->
      if @element.is('input') and !@singleDatePicker and @autoUpdateInput
        @element.val @startDate.format(@locale.format) + @locale.separator + @endDate.format(@locale.format)
        @element.trigger 'change'
      else if @element.is('input') and @autoUpdateInput
        @element.val @startDate.format(@locale.format)
        @element.trigger 'change'
      return
    remove: ->
      @container.remove()
      @element.off '.daterangepicker'
      @element.removeData()
      return

  $.fn.daterangepicker = (options, callback) ->
    @each ->
      el = $(this)
      if el.data('daterangepicker')
        el.data('daterangepicker').remove()
      el.data 'daterangepicker', new DateRangePicker(el, options, callback)
      return
    this

  DateRangePicker

# ---
# generated by js2coffee 2.2.0