Fabricator(:resource) do
  plan { "enterprise-#{SecureRandom.uuid}" }
  name { "acme-inc-primary-database" }
  region { ["amazon-web-services::us-east-1", "amazon-web-services::eu-west-1"].sample }
  oauth_grant {
    {
      code: SecureRandom.uuid,
      expires_at: 5.minutes.from_now,
      type: "authorization_code"
    }
  }
  heroku_uuid { SecureRandom.uuid }
  callback_url do |attrs|
    "https://api.heroku.com/vendor/apps/#{attrs[:uuid]}"
  end
end
