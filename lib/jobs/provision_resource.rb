class Jobs::ProvisionResource < Jobs::Base
  def run(heroku_uuid)
    resource = Resource[heroku_uuid: heroku_uuid]
    client = Clients::Heroku.new(resource)
    resource.update(oauth_token_data: client.exchange_grant_code)
    client.set_config(
      "NAME" => "foo",
    )
    client.mark_provisioned
  end
end
