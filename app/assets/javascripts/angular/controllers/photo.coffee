#inject angular file upload directives and service.

PhotoCaption.controller 'PhotoController', ($scope, $upload, Restangular) ->
  $scope.imageUrl       = null
  $scope.uploadedFile   = null
  $scope.caption        = ''
  $scope.photo          = null

  $scope.onFileSelect = ($files) ->    
    #$files: an array of files selected, each file has name, size, and type.
    i = 0
    while i < $files.length
      @uploadedFile = $files[i]

      $scope.upload = $upload.upload(
        url: '/photos'
        data:
          caption: @caption

        file: @uploadedFile
      ).progress((evt) ->
        console.log "percent: " + parseInt(100.0 * evt.loaded / evt.total)
        
      ).success((data, status, headers, config) =>

        console.log(data)
        @photo = data.photo
        @imageUrl = data.url
      )
      i++

  $scope.captionChanged = () ->
    if @uploadedFile
      Restangular.one('photos', @photo.id).customPUT(photo: 
        caption:@caption
      ).then (data) =>
        console.log(data)
        @imageUrl = data.url + Math.random(10000)