json.array! @photos.each do |photo|
  json.id photo.id
  json.caption photo.caption
  json.polaroid_url photo.image.url(:polaroid)
  json.thumb_url photo.image.url(:polaroid_thumb)
end