class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [300, 200]
  end

  version :medium do
    process resize_to_fill: [600, 400]
  end

  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  def size_range
    1.byte..5.megabytes
  end
end