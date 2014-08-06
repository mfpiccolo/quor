# encoding: utf-8

class BannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  process :resize_to_fit => [580, 300]

  # Choose what kind of storage to use for this uploader:
  # storage  :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/email_templates_details/banners/"
  end

end
