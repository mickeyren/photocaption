class Photo < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, 
                    styles: { 
                      copy: ['640x', :png], 
                      polaroid: ['1x1', :png], 
                      polaroid_thumb: ['1x1', :png], 
                      thumb: ['100x100>', :png] 
                    }, 
                    default_url: '/images/:style/missing.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end