CarrierWave.configure do |config|
  config.storage = (Rails.env.production? or Rails.env.staging?) ? :fog : :file
  config.fog_credentials = {
    provider:              "AWS",
    aws_access_key_id:     ENV["INTRINSIC_AWS_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["INTRINSIC_AWS_SECRET_ACCESS_KEY"],
    region:                ENV["INTRINSIC_AWS_REGION"],

    # Socket persistence (via fog's use of excon).
    #
    # Set this to false to ensure a new connection is used each time,
    # preventing the situation where long running requests will exceed Nginx's
    # threshold, issue another request to a application instance and ultimately
    # result in duplicate records in the database and intermittent empty
    # responses from Nginx.
    #
    # Further detail: https://github.com/fog/fog/issues/1021
    #
    # Note: This is the default in fog v1.5.0+, but the backup gem has been
    # requiring fog ~> v1.4.0 for ages, so this is explicitly set here.
    persistent: false
  }
  # Make files public.
  config.fog_public        = true

  # S3 bucket name.
  config.fog_directory     = "intrinsic-assets-#{Rails.env}"

  # Disable version processing in test environment.
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.enable_processing = true
  end

end
