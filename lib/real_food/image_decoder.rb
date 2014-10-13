module RealFood
  class ImageDecoder
    def self.decode_jpg(image_data)
      data = StringIO.new(Base64.decode64(image_data))
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.content_type = "image/jpeg"
      data.original_filename = "picture.jpeg"
      return data
    end
  end
end
