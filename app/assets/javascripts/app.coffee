HomeController = ($scope, $window, $http) ->
  $http.get('/posts').success (posts) ->
    $scope.posts = posts
    $scope.facebook = _.filter posts, (obj) -> /@face/.test obj.idr
    #$scope.facebook = [posts[1]]

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
      }, 'swing'
  ).config([ '$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider.when('/',
      templateUrl: '/partials/index.html'
      controller: HomeController
    ).otherwise redirectTo: '/'
  ])