class Clients::Heroku < Clients::Base
  def initialize(resource)
    self.resource = resource
  end

  def set_config(config={})
    config = { config: config.map do |k, v|
                 {
                   "name": k,
                   "value": v
                 }
      end
    }

    MultiJson.load(Excon.patch("https://api.heroku.com/addons/#{resource.heroku_uuid}/config",
      body: MultiJson.dump(config),
      headers: api_headers,
      idempotent: true,
      expects: [200]
    ).body)
  end

  def show_config
    MultiJson.load(Excon.get("https://api.heroku.com/addons/#{resource.heroku_uuid}/config",
      headers: api_headers,
      idempotent: true,
      expects: [200]
    ).body)
  end

  def mark_provisioned
    MultiJson.load(Excon.post("https://api.heroku.com/addons/#{resource.heroku_uuid}/actions/provision",
      headers: api_headers,
      idempotent: true,
      expects: [200]
    ).body)
  end

  def exchange_grant_code
    # TODO if grant has expired fail resource provisioning
    MultiJson.load(Excon.post("https://id.heroku.com/oauth/token",
      body: URI.encode_www_form(
        grant_type: resource.oauth_grant['type'],
        code: resource.oauth_grant['code'],
        client_secret: Config.oauth_client_secret
      ),
      headers: { "Content-Type" => "application/x-www-form-urlencoded" },
      idempotent: true,
      expects: [200]
    ).body)
  end

  private

  attr_accessor :resource

  def api_headers
    {
      "Content-Type" => "application/json",
      "Accept" => "application/vnd.heroku+json; version=3",
      "Authorization" => "#{resource.oauth_token_data['token_type']} #{resource.oauth_token_data['access_token']}"
    }
  end
end
