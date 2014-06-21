window.PhotoCaption = angular.module "PhotoCaption", ['angularFileUpload', 'angular-loading-bar', 'restangular']


PhotoCaption.run ($rootScope) ->
  $("#drop-box").fitText 1.2,
    minFontSize: '60px'
    maxFontSize: '100px'


