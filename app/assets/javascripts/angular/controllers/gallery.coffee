#inject angular file upload directives and service.

PhotoCaption.controller 'GalleryController', ($scope, Restangular) ->
  Restangular.all('photos').getList().then (data) =>
    console.log(data[0])
    $scope.photos = data