
window.PhotoCaption = angular.module "PhotoCaption", ['angularFileUpload', 'angular-loading-bar', 'restangular', 'ngRoute']

PhotoCaption.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/',
      controller:  'PhotoController'
      templateUrl: 'photo.html'
      page_title: -> 'Photo Caption'

    .when '/about',
      controller:  'AboutController'
      templateUrl: 'about.html'
      page_title: -> 'About Photo Caption'

    .when '/gallery',
      controller:  'GalleryController'
      templateUrl: 'gallery.html'
      page_title: -> 'Photo Caption Gallery'    

    .otherwise
      templateUrl: '404.html'
      page_title: -> "Not Found"      
]


PhotoCaption.run ($rootScope, Restangular) ->
  $("#drop-box").fitText 1.2,
    minFontSize: '60px'
    maxFontSize: '120px'

  Restangular.setRequestSuffix('.json')