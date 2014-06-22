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
    
    create_polaroid_version(photo.image, photo.caption)
    create_polaroid_thumb_version(photo.image)

    if photo
      render json: { photo: photo, url: photo.image.url(:polaroid) }
    else

    end
  end

  def update
    photo = Photo.find params[:id]
    photo.update_attributes(photo_params)

    update_image_caption(photo.image, photo_params[:caption]) if photo_params[:caption]
    
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

    def create_polaroid_version(photo_image, caption)
      image = Magick::Image.read(photo_image.path(:copy)).first

      #image.border!(18, 58, "#f0f0ff")
      image = image.frame(25, 50, 25, 15, 0, 0, '#fefefe')
      image.transparent_color = '#ff1493'
      image.background_color = 'none'

      amplitude = image.columns * 0.01
      wavelength = image.rows  * 2

      image.rotate!(90)
      image = image.wave(amplitude, wavelength)
      image.rotate!(-90)

      # text = Draw.new
      # text.annotate(image, 0, 0, 0, 20, caption) do
      #   self.gravity = Magick::SouthGravity
      #   self.pointsize = 50
      #   self.font_family = 'Arial'
      #   self.stroke = 'none'
      # end

      image.rotate!(rand(15) * -1 + rand(15))
      # image.trim!

      out = photo_image.path(:polaroid).sub(/\./, ".")
      Rails.logger.debug out
      image.transparent('#ff1493').write(out)
    end

    def create_polaroid_thumb_version(photo_image)
      image = Magick::Image.read(photo_image.path(:thumb)).first

      #image.border!(18, 58, "#f0f0ff")
      image = image.frame(6, 12, 6, 5, 0, 0, '#fefefe')
      image.transparent_color = '#ff1493'
      image.background_color = 'none'

      amplitude = image.columns * 0.01
      wavelength = image.rows  * 2

      image.rotate!(90)
      image = image.wave(amplitude, wavelength)
      image.rotate!(-90)

      image.rotate!(rand(15) * -1 + rand(15))

      out = photo_image.path(:polaroid_thumb).sub(/\./, ".")
      image.transparent('#ff1493').write(out)
    end

    def update_image_caption(photo_image, caption)
      image = Magick::Image.read(photo_image.path(:copy)).first

      #image.border!(18, 58, "#f0f0ff")
      image = image.frame(25, 50, 25, 15, 0, 0, '#fefefe')
      image.transparent_color = '#ff1493'
      image.background_color = 'none'

      amplitude = image.columns * 0.01
      wavelength = image.rows  * 2

      image.rotate!(90)
      image = image.wave(amplitude, wavelength)
      image.rotate!(-90)

      text = Draw.new
      text.annotate(image, 0, 0, 0, 20, caption) do
        self.gravity = Magick::SouthGravity
        self.pointsize = 40
        self.font_family = 'Arial'
        self.stroke = 'none'
      end

      image.rotate!(rand(15) * -1 + rand(15))
      image.trim!

      out = photo_image.path(:polaroid).sub(/\./, ".")
      image.transparent('#ff1493').write(out)
    end
    
end
