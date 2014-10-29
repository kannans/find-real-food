class UploadedFile
  # The basename of the file in the client.
  attr_accessor :original_filename

  # A string with the MIME type of the file.
  attr_accessor :content_type

  # A +Tempfile+ object with the actual uploaded file. Note that some of
  # its interface is available directly.
  attr_accessor :tempfile
  alias :to_io :tempfile

  # A string with the headers of the multipart request.
  attr_accessor :headers

  def initialize(hash) # :nodoc:
    @tempfile          = hash[:tempfile]
    raise(ArgumentError, ':tempfile is required') unless @tempfile

    @original_filename = encode_filename(hash[:filename])
    @content_type      = hash[:type]
    @headers           = hash[:head]
  end