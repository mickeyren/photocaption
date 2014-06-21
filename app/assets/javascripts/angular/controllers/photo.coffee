#inject angular file upload directives and service.

PhotoCaption.controller 'PhotoController', ($scope, $upload, Restangular) ->
  $scope.imageUrl = null
  $scope.uploadedFile = null
  $scope.caption = ''

  $scope.onFileSelect = ($files) ->    
    #$files: an array of files selected, each file has name, size, and type.
    i = 0
    while i < $files.length
      @uploadedFile = $files[i]
      #upload.php script, node.js route, or servlet url
      # method: 'POST' or 'PUT',
      # headers: {'header-key': 'header-value'},
      # withCredentials: true,
      # or list of files: $files for html5 only
      # set the file formData name ('Content-Desposition'). Default is 'file' 
      
      #fileFormDataName: myFile, //or a list of names for multiple files (html5).
      # customize how data is added to formData. See #40#issuecomment-28612000 for sample code 
      
      #formDataAppender: function(formData, key, val){}
      $scope.upload = $upload.upload(
        url: '/photos'
        data:
          caption: @caption

        file: @uploadedFile
      ).progress((evt) ->
        console.log "percent: " + parseInt(100.0 * evt.loaded / evt.total)
        
      ).success((data, status, headers, config) =>
        
        # file is uploaded successfully
        console.log(data)
        @imageUrl = data.url
      )
      i++

  $scope.captionChanged = () ->
    console.log(@caption)
    Restangular.one('photos', 1).customPUT({caption:@caption}).then (data) =>
      console.log(data)
      @imageUrl = data.url + Math.random(10000)
    
    # .getList().then (users) ->
    #   # returns a list of users
    #   $scope.user = users[0] # first Restangular obj in list: { id: 123 }
    #   return



#.error(...)
#.then(success, error, progress); 
#.xhr(function(xhr){xhr.upload.addEventListener(...)})// access and attach any event listener to XMLHttpRequest.

# alternative way of uploading, send the file binary with the file's content-type.
#       Could be used to upload files to CouchDB, imgur, etc... html5 FileReader is needed. 
#       It could also be used to monitor the progress of a normal http post/put request with large data

# $scope.upload = $upload.http({...})  see 88#issuecomment-31366487 for sample code.