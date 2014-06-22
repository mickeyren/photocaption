include Magick

class PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :load_user

  def index
    @photos = @user.photos
  end

  def create
    photo = Photo.new
    photo.caption = params[:caption]
    photo.image = params[:file]

    @user.photos << photo
    
    photo.polaroid!(photo.image.path(:copy), photo.image.path(:polaroid))
    photo.polaroid!(photo.image.path(:thumb), photo.image.path(:polaroid_thumb), true)

    if photo
      render json: { photo: photo, url: photo.image.url(:polaroid) }
    else
    end
  end

  def update
    photo = Photo.find params[:id]
    photo.update_attributes(photo_params)

    photo.polaroid!(photo.image.path(:copy), photo.image.path(:polaroid), false, photo_params[:caption])
    
    render json: { url: photo.image.url(:polaroid) }
  end

  protected
    def photo_params
      params.require(:photo).permit(:caption)
    end

    def load_user
      @user = User.find_by_name(request.ip)
      if @user.nil?
        @user = User.create(name: request.ip)
      end
    end
end
