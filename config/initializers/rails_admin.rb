RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.excluded_models << "Filter"
  config.excluded_models << "DropDownList"
  config.excluded_models << "FilterGroup"
  config.excluded_models << "NotificationTemplate"
  config.excluded_models << "RuleEngine"

  config.authorize_with do
    authenticate_or_request_with_http_basic('Please enter your username and password') do |username, password|
      (username == ADMIN_USERNAME && password == ADMIN_PASSWORD)
    end
  end
  config.navigation_static_label = ""
  config.navigation_static_links = {
  'Filters' => "/filters",
  "Groups" => "/filter_groups",
  "Rules" => "/rule_engines",
  "Admin Notifications" => "/notification_templates",
  "Description Keys" => "/notification_templates/merge_fields_key"
}

end
