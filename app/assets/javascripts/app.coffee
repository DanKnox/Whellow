HomeController = ($scope, $window, $http, $cookies) ->
  $scope.all_posts = () -> $scope.selected_posts = $scope.posts
  $scope.linkedin_posts = () -> $scope.selected_posts = $scope.linkedin
  $scope.facebook_posts = () -> $scope.selected_posts = $scope.facebook
  $scope.my_posts = () -> $scope.selected_posts = $scope.posts

  $http.get('/logged_in').success (rsp) ->
    unless rsp.authed
      $scope.auth = 'false'
    else
      $scope.auth = 'true'
      $scope.user = rsp.user
      $scope.logout = () ->
        delete $cookies.access_token
        $window.location = '/signout'
      $http.get('/posts').success (posts) ->
        $scope.posts = _.map posts, (obj) ->
          if /@face/.test(obj.idr) && obj.data.message
            obj.username = obj.data.from.name
            obj.picture  = 'http://graph.facebook.com/' + obj.data.from.id + '/picture'
            obj.message  = obj.data.message
            obj.service  = 'facebook'
            obj
          else if /@link/.test obj.idr
            obj.username = obj.data.updateContent.firstName + ' '  + obj.data.updateContent.lastName
            obj.picture  = obj.data.updateContent.pictureUrl
            obj.message  = obj.data.updateContent.currentStatus
            obj.service  = 'linkedin'
            obj
        $scope.facebook = _.filter posts, (obj) -> obj.service == 'facebook' && obj.data.message
        $scope.linkedin  = _.filter posts, (obj) -> obj.service == 'linkedin'
        $scope.selected_posts = _.compact $scope.posts

angular.module('whellow', ['ngCookies'])
  .directive('moment', () -> (scope, element, attrs) -> element.html moment(scope.post.at).fromNow() )
  .directive('rotate', () -> (scope, element, attrs) ->
    if scope.post
      [hour, minute] = moment(scope.post.at).format('h m').split(' ')
    else
      date = new Date()
      hour = date.getHours()
      hour -= 12 if hour > 12
      minute = date.getMinutes()
    console.log attrs.rotate
    if attrs.rotate == 'minute'
      rotation = 6 * minute
    else
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
          if scope.post
            circle = element.children('.circle')
            off_left = circle.offset().left
            off_top  = circle.offset().top
            left = off_left - element.parent().offset().left
            top = off_top - element.parent().offset().top - 25
            element.after '<div class="tooltip" style="left:' + left + 'px;top:' + top + 'px">' + scope.post.message + '</div>'
            circle.hover(
              () -> element.next().animate { opacity: 0.75 }, 250, 'linear'
              () -> element.next().animate { opacity: 0 }, 250, 'linear'
            )
            circle.click () ->
              $('#feed').scrollTo('#id' + scope.post.id, 600, {easing: 'swing'})
      }, 'swing'
  ).config([ '$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider.when('/',
      templateUrl: '/partials/index.html'
      controller: HomeController
    ).otherwise redirectTo: '/'
  ])