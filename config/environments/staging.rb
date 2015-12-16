Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true
  config.serve_static_assets = true

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'
  
  config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'gmail.com',
      user_name:            'realifexdev@gmail.com',
      password:             'p4p3rk1t3',
      authentication:       'plain',
      enable_starttls_auto: true
    }
  
  config.action_mailer.default_url_options = {:host => 'realifex-staging.elasticbeanstalk.com'}

  config.apple_receipt_validation_url = "https://sandbox.itunes.apple.com"
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  AWS_ACCESS_KEY_ID = ENV["AWS_ACCESS_KEY_ID"]
  AWS_SECRET_ACCESS_KEY = ENV["AWS_SECRET_KEY"]
  AWS_BUCKET_NAME = ENV["AWS_BUCKET_NAME"]
  ADMIN_USERNAME= ENV["ADMIN_USERNAME"]
  ADMIN_PASSWORD= ENV["ADMIN_PASSWORD"]

end