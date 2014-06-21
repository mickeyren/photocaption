class Photo < ActiveRecord::Base
  
  has_attached_file :image, 
                    styles: { 
                      copy: ['640x480>', :png], 
                      polaroid: ['1x1>', :png], 
                      thumb: ['100x100>', :png] 
                    }, 
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end