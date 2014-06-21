class PhotosController < ApplicationController
  
  skip_before_action :verify_authenticity_token

  def create
    photo = Photo.new
    photo.image = params[:file]
    photo.save
  end
  
end
