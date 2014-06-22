class Photo < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, 
                    styles: { 
                      copy: ['', :png], 
                      thumb: ['100x100>', :png],
                      polaroid: ['1x1', :png], 
                      polaroid_thumb: ['1x1', :png], 
                    }, 
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def polaroid!(source, dest, thumb = false, caption = nil)
    image = Magick::Image.read(source).first

    if thumb
      image = image.frame(6, 12, 6, 5, 0, 0, '#fefefe')
    else
      image = image.frame(25, 50, 25, 15, 0, 0, '#fefefe') 
    end

    image.transparent_color = '#ff1493'
    image.background_color = 'none'

    amplitude = image.columns * 0.01
    wavelength = image.rows  * 2

    image.rotate!(90)
    image = image.wave(amplitude, wavelength)
    image.rotate!(-90)

    if caption
      text = Draw.new
      text.annotate(image, 0, 0, 0, 20, caption) do
        self.gravity = Magick::SouthGravity
        self.pointsize = 40
        self.font_family = 'Arial'
        self.stroke = 'none'
      end
    end

    image.rotate!(rand(15) * -1 + rand(15))

    out = dest.sub(/\./, ".")
    image.transparent('#ff1493').write(out)
  end

end