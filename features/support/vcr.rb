# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'features/support/fixtures/cassettes'

  #c.debug_logger = File.open('features/support/record.log', 'w')
  
  # Avoid conflict with Selenium
  c.ignore_localhost = true

  c.default_cassette_options = {
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:imp, :prev_imp, :distinct_id)
    ]
  }
  c.filter_sensitive_data('<SLACK_AUTH_TOKEN>') { ENV['SLACK_AUTH_TOKEN'] }
  c.filter_sensitive_data('<GITTER_API_TOKEN>') { ENV['GITTER_API_TOKEN'] }
  c.filter_sensitive_data('<GITHUB_CLIENT_ID>') { ENV['GITHUB_KEY'] }
  c.filter_sensitive_data('<GITHUB_CLIENT_SECRET>') { ENV['GITHUB_SECRET'] }
  c.filter_sensitive_data('<AUTHORIZATION_HEADERS>') do |interaction|
    interaction.request.headers['Authorization'].try(:first)
  end
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
