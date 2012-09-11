HomeController = ($scope, $window, $http) ->
  $http.get('/posts').success (posts) ->
    $scope.posts = posts
    $scope.facebook = _.filter posts, (obj) -> /@face/.test obj.idr

angular.module('whellow', [])
  .directive('rotate', () -> (scope, element, attrs) ->
    [hour, minute] = moment(scope.post.at).format('h m').split(' ')
    rotation = (30 * parseInt(hour)) + (30 / (1.66 * parseInt(minute)))
    rotation -= 360 if rotation > 360
    element.animate { rotation: rotation },
      {
        duration: 1750
        step: (n) ->
          element.css {
            '-webkit-transform': 'rotate(' + n + 'deg)',
            '-moz-transform': 'rotate(' + n + 'deg)',
            '-ms-transform': 'rotate(' + n + 'deg)',
            '-o-transform': 'rotate(' + n + 'deg)',
            'transform': 'rotate(' + n + 'deg)'
          }
        complete: () ->
          circle = element.children('.circle')
          off_left = circle.offset().left
          off_top  = circle.offset().top
          left = off_left - element.parent().offset().left
          top = off_top - element.parent().offset().top - 25
          element.after '<div class="tooltip" style="left:' + left + 'px;top:' + top + 'px">' + scope.post.data.message + '</div>'
          circle.hover(
            () -> element.next().animate { opacity: 0.75 }, 250, 'linear'
            () -> element.next().animate { opacity: 0 }, 250, 'linear'
          )
      }, 'swing'
  ).config([ '$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider.when('/',
      templateUrl: '/partials/index.html'
      controller: HomeController
    ).otherwise redirectTo: '/'
  ])