'use strict'

angular.module('nouislider', [])
  .directive "slider", () ->
    restrict: "A"
    scope:
      start: "@"
      step: "@"
      end: "@"
      connect: "@"
      orientation: "@"
      callback: "@"
      slide: "&"
      set: "&"
      change: "&"
      margin: "@"
      ngModel: "="
      ngFrom: "="
      ngTo: "="

    link: (scope, element, attrs) ->
      slider = $(element)

      callback = if scope.callback then scope.callback else 'slide'
      slide = if scope.slide then scope.slide else -> return
      set = if scope.set then scope.set else -> return
      change = if scope.change then scope.change else -> return

      if scope.ngFrom? and scope.ngTo?
        fromParsed = null
        toParsed = null
        connect = scope.connect is true

        slider.noUiSlider
          start: [scope.ngFrom or scope.start, scope.ngTo or scope.end]
          step: parseFloat(scope.step or 1)
          connect: connect
          margin: parseFloat(scope.margin or 0)
          orientation: scope.orientation || "horizontal"
          range:
            min: [parseFloat scope.start]
            max: [parseFloat scope.end]


        slider.on callback, ->
          [from, to] = slider.val()

          fromParsed = parseFloat from
          toParsed = parseFloat to

          scope.$apply(->
            scope.ngFrom = fromParsed
            scope.ngTo = toParsed
          )

        scope.$watch('ngFrom', (newVal, oldVal) ->
          if newVal isnt fromParsed
            slider.val([newVal, null])
        )

        scope.$watch('ngTo', (newVal, oldVal) ->
          if newVal isnt toParsed
            slider.val([null, newVal])
        )
      else
        parsedValue = null
        connect = false

        if scope.connect is "lower" or scope.connect is "upper"
          connect = scope.connect

        slider.noUiSlider
          start: [scope.ngModel or scope.start],
          step: parseFloat(scope.step or 1)
          connect: connect
          orientation: scope.orientation || "horizontal"
          range:
            min: [parseFloat scope.start]
            max: [parseFloat scope.end]

        slider.on callback, ->
          parsedValue = parseFloat slider.val()
          scope.$apply ->
            scope.ngModel = parsedValue

        scope.$watch('ngModel', (newVal, oldVal) ->
          if newVal isnt parsedValue
            slider.val(newVal)
        )
      slider.on 'set', (event, value) ->
        set event, value
      slider.on 'slide', (event, value) ->
        slide event, value
      slider.on 'change', (event, value) ->
        change event, value
      return
