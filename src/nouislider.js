'use strict';
angular.module('nouislider', []).directive('slider', function () {
  return {
    restrict: 'A',
    scope: {
      start: '@',
      step: '@',
      end: '@',
      connect: '@',
      orientation: '@',
      callback: '@',
      slide: '&',
      set: '&',
      change: '&',
      margin: '@',
      ngModel: '=',
      ngFrom: '=',
      ngTo: '='
    },
    link: function (scope, element, attrs) {
      var callback, change, connect, fromParsed, parsedValue, set, slide, slider, toParsed;
      slider = $(element);
      callback = scope.callback ? scope.callback : 'slide';
      slide = scope.slide ? scope.slide : function () {
      };
      set = scope.set ? scope.set : function () {
      };
      change = scope.change ? scope.change : function () {
      };
      if (scope.ngFrom != null && scope.ngTo != null) {
        fromParsed = null;
        toParsed = null;
        connect = scope.connect === true;
        slider.noUiSlider({
          start: [
            scope.ngFrom || scope.start,
            scope.ngTo || scope.end
          ],
          step: parseFloat(scope.step || 1),
          connect: connect,
          margin: parseFloat(scope.margin || 0),
          orientation: scope.orientation || 'horizontal',
          range: {
            min: [parseFloat(scope.start)],
            max: [parseFloat(scope.end)]
          }
        });
        slider.on(callback, function () {
          var from, to, _ref;
          _ref = slider.val(), from = _ref[0], to = _ref[1];
          fromParsed = parseFloat(from);
          toParsed = parseFloat(to);
          return scope.$apply(function () {
            scope.ngFrom = fromParsed;
            return scope.ngTo = toParsed;
          });
        });
        scope.$watch('ngFrom', function (newVal, oldVal) {
          if (newVal !== fromParsed) {
            return slider.val([
              newVal,
              null
            ]);
          }
        });
        scope.$watch('ngTo', function (newVal, oldVal) {
          if (newVal !== toParsed) {
            return slider.val([
              null,
              newVal
            ]);
          }
        });
      } else {
        parsedValue = null;
        connect = false;
        if (scope.connect === 'lower' || scope.connect === 'upper') {
          connect = scope.connect;
        }
        slider.noUiSlider({
          start: [scope.ngModel || scope.start],
          step: parseFloat(scope.step || 1),
          connect: connect,
          orientation: scope.orientation || 'horizontal',
          range: {
            min: [parseFloat(scope.start)],
            max: [parseFloat(scope.end)]
          }
        });
        slider.on(callback, function () {
          parsedValue = parseFloat(slider.val());
          return scope.$apply(function () {
            return scope.ngModel = parsedValue;
          });
        });
        scope.$watch('ngModel', function (newVal, oldVal) {
          if (newVal !== parsedValue) {
            return slider.val(newVal);
          }
        });
      }
      slider.on('set', function (event, value) {
        return set(event, value);
      });
      slider.on('slide', function (event, value) {
        return slide(event, value);
      });
      slider.on('change', function (event, value) {
        return change(event, value);
      });
    }
  };
});  /*
//@ sourceMappingURL=app.js.map
*/