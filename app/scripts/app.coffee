'use strict'

angular.module('nouislider', [])
  .directive "slider", () ->
    restrict: "A"
    scope:
      min: "@"
      step: "@"
      max: "@"
      connect: "@"
      orientation: "@"
      callback: "@"
      slide: "&slide"
      set: "&set"
      change: "&change"
      margin: "@"
      ngModel: "="
      ngFrom: "="
      ngTo: "="
      ngMin: "="
      ngMax: "="

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
          start: [scope.ngFrom or scope.ngMin or scope.min, scope.ngTo or scope.ngMax or scope.max]
          step: parseFloat(scope.step or 1)
          connect: connect
          margin: parseFloat(scope.margin or 0)
          orientation: scope.orientation || "horizontal"
          range:
            min: [parseFloat scope.ngMin or scope.min]
            max: [parseFloat scope.ngMax or scope.max]


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
          start: [scope.ngModel or scope.ngMin or scope.min],
          step: parseFloat(scope.step or 1)
          connect: connect
          orientation: scope.orientation || "horizontal"
          range:
            min: [parseFloat scope.ngMin or scope.min]
            max: [parseFloat scope.ngMax or scope.max]

        slider.on callback, ->
          parsedValue = parseFloat slider.val()
          scope.$apply ->
            scope.ngModel = parsedValue

        scope.$watch('ngModel', (newVal, oldVal) ->
          if newVal isnt parsedValue
            slider.val(newVal)
        )
      slider.on 'set', (event, value) ->
        set
          event: event
          value: value
        return
      slider.on 'slide', (event, value) ->
        slide
          event: event
          value: value
        return
      slider.on 'change', (event, value) ->
        change
          event: event
          value: value
        return
      scope.$watch('ngMin', (newVal, oldVal) ->
        slider.noUiSlider
          range:
            min: [parseFloat(newVal || scope.min)]
            max: [parseFloat(scope.ngMax || scope.max)],
          true
        return
      )
      scope.$watch('ngMax', (newVal, oldVal) ->
        slider.noUiSlider
          range:
            min: [parseFloat(scope.ngMin || scope.min)]
            max: [parseFloat(newVal || scope.max)],
          true
        return
      )
      return
