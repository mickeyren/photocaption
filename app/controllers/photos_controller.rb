include Magick

class PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token

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
    image = Photo.last.image
    update_image_caption(image, params[:caption]) if params[:caption]
    
    render json: { url: image.url(:polaroid) }
  end

  private
    def create_polaroid_version(photo_image, caption)
      image = Magick::Image.read(photo_image.path).first

      #image.border!(18, 58, "#f0f0ff")
      image = image.frame(25, 50, 25, 15, 0, 0, '#ffffff')

      image.background_color = "none"

      amplitude = image.columns * 0.01
      wavelength = image.rows  * 2

      image.rotate!(90)
      image = image.wave(amplitude, wavelength)
      image.rotate!(-90)

      shadow = image.flop
      shadow = shadow.colorize(1, 1, 1, "gray75")
      shadow.background_color = "white"
      shadow.border!(10, 10, "white")
      shadow = shadow.blur_image(0, 3)

      image = shadow.composite(image, -amplitude/2, 5,
                               Magick::OverCompositeOp)
      text = Draw.new
      text.annotate(image, 0, 0, 0, 25, caption) do
        self.gravity = Magick::SouthGravity
        self.pointsize = 50
        self.font_family = 'Arial'
        self.stroke = 'none'
      end

      image.rotate!(rand(10))
      image.trim!

      out = photo_image.path(:polaroid).sub(/\./, ".")
      image.write(out)
    end

    def update_image_caption(photo_image, caption)
      image = Magick::Image.read(photo_image.path).first

      #image.border!(18, 58, "#f0f0ff")
      image = image.frame(25, 50, 25, 15, 0, 0, '#ffffff')

      image.background_color = "none"

      amplitude = image.columns * 0.01
      wavelength = image.rows  * 2

      image.rotate!(90)
      image = image.wave(amplitude, wavelength)
      image.rotate!(-90)

      shadow = image.flop
      shadow = shadow.colorize(1, 1, 1, "gray75")
      shadow.background_color = "white"
      shadow.border!(10, 10, "white")
      shadow = shadow.blur_image(0, 3)

      image = shadow.composite(image, -amplitude/2, 5,
                               Magick::OverCompositeOp)
      text = Draw.new
      text.annotate(image, 0, 0, 0, 25, caption) do
        self.gravity = Magick::SouthGravity
        self.pointsize = 50
        self.font_family = 'Arial'
        self.stroke = 'none'
      end

      image.rotate!(rand(10))
      image.trim!

      out = photo_image.path(:polaroid).sub(/\./, ".")
      image.write(out)
    end
    
end
