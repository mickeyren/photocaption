#inject angular file upload directives and service.

PhotoCaption.controller 'GalleryController', [
  '$scope'
  'Restangular'
  'Photos'
  ($scope, Restangular, Photos) ->
    Photos.getList().then (data) =>
      console.log(data[0])
      $scope.photos = data
]