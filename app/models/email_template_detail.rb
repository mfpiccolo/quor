class EmailTemplateDetail < ActiveRecord::Base
  mount_uploader :logo_file, LogoUploader
  mount_uploader :banner_file, BannerUploader
end
