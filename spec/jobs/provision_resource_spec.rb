require "spec_helper"

RSpec.describe Jobs::ProvisionResource do
  let(:access_token) { SecureRandom.uuid }
  let(:refresh_token) { SecureRandom.uuid }
  let!(:resource) { Fabricate(:resource) }

  before do
    stub_oauth_token_exchange
    stub_config_update
    stub_mark_provisioned
  end

  it "exchanges the oauth grant for tokens" do
    run
    expect(resource.reload.oauth_token_data['access_token']).to eq access_token
  end

  it "sets config" do
    run
  end

  it "marks the resource as provisioned" do
    run
  end

  def stub_mark_provisioned
    Excon.stub(
      {
        path: "/addons/#{resource.heroku_uuid}/actions/provision",
        method: 'post'
      },
      {
        body: MultiJson.dump({}),
        status: 200
      }
    )
  end

  def stub_config_update
    body = {
      "config": [
        {
          "name": "NAME",
          "value": "foo"
        }
      ]
    }
    Excon.stub(
      {
        path: "/addons/#{resource.heroku_uuid}/config",
        method: 'patch'
      },
      lambda do |request_params|
        expect(MultiJson.dump(body)).to eq request_params[:body]
        {
          body: MultiJson.dump({}),
          status: 200
        }
      end
    )
  end

  def stub_oauth_token_exchange
    oauth_tokens = {
      access_token: access_token,
      refresh_token: refresh_token,
      expires_in: 28800,
      token_type: "Bearer"
    }

    Excon.stub(
      { url: "https://id.heroku.com/oauth/token", method: 'post' },
      {
        body: MultiJson.dump(oauth_tokens),
        status: 200
      }
    )
  end

  def run
    described_class.run(resource.heroku_uuid)
  end
end
