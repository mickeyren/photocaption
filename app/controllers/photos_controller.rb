include Magick

class PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @photos = Photo.all
  end

  def create
    photo = Photo.new
    photo.caption = params[:caption]
    photo.image = params[:file]
    photo.save
    
    create_polaroid_version(photo.image, photo.caption)

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

      # shadow = image.flop
      # shadow = shadow.colorize(1, 1, 1, "gray75")
      # shadow.background_color = "white"
      # shadow.border!(10, 10, "white")
      # shadow = shadow.blur_image(0, 3)

      # image = shadow.composite(image, -amplitude/2, 5,
      #                          Magick::OverCompositeOp)
      text = Draw.new
      text.annotate(image, 0, 0, 0, 20, caption) do
        self.gravity = Magick::SouthGravity
        self.pointsize = 50
        self.font_family = 'Arial'
        self.stroke = 'none'
      end

      image.rotate!(rand(15) * -1 + rand(15))
      image.trim!

      out = photo_image.path(:polaroid).sub(/\./, ".")
      image.transparent('#ff1493').write(out)
    end
    
end
