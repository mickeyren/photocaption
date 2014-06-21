include Magick

class PhotosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    photo = Photo.new
    photo.caption = params[:caption]
    photo.image = params[:file]
    photo.save
    
    Rails.logger.debug 'using rmagick...'
    image = Magick::Image.read(photo.image.path).first


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
    text.annotate(image, 0, 0, 0, 25, photo.caption) do
      self.gravity = Magick::SouthGravity
      self.pointsize = 50
      self.font_family = 'Arial'
      self.stroke = 'none'
    end

    image.rotate!(-5)
    image.trim!

    out = photo.image.path.sub(/\./, ".")
    Rails.logger.debug "Writing #{out}"
    image.write(out)

    if photo.save
      render json: { photo: photo, url: photo.image.url }
    else

    end
  end
  
end
