require "spec_helper"

RSpec.describe Endpoints::Heroku::Resources do
  include Rack::Test::Methods

  def app
    Endpoints::Heroku::Resources
  end

  before do
    authorize ENV['HEROKU_USERNAME'], ENV['HEROKU_PASSWORD']
    header "Content-Type", "application/json"
    env "HTTP_X_API_VERSION", "3"
  end

  describe "POST /heroku/resources" do
    let(:resource_attributes) { Fabricate.attributes_for(:resource) }
    let(:resource) { double(heroku_uuid: resource_attributes['heroku_uuid']) }
    let(:params) do
      {
        plan: resource_attributes[:plan],
        name: resource_attributes[:name],
        oauth_grant: resource_attributes[:oauth_grant],
        region: resource_attributes[:region],
        uuid: resource_attributes[:heroku_uuid],
        callback_url: resource_attributes[:callback_url]
      }
    end

    it "calls the mediator" do
      expect(Mediators::Resources::Creator).to receive(:run).and_return(resource)
      post "/heroku/resources", MultiJson.encode(params)
      expect(last_response.status).to eq(202)
    end
  end

  describe "PUT /heroku/resources/:id" do
    let!(:resource) { Fabricate(:resource, plan: 'starter') }
    let(:params) do
      {
        heroku_uuid: resource.heroku_uuid,
        plan: 'advanced'
      }
    end

    it "calls the mediator" do
      expect(Mediators::Resources::Updater).to receive(:run).and_return(resource)
      put "/heroku/resources/#{resource.heroku_uuid}", MultiJson.encode(params)
      expect(last_response.status).to eq(200)
    end
  end

  describe "DELETE /heroku/resources/:id" do
    let!(:resource) { Fabricate(:resource) }

    it "calls the mediator" do
      expect(Mediators::Resources::Destroyer).to receive(:run)
      delete "/heroku/resources/#{resource.heroku_uuid}"
      expect(last_response.status).to eq(204)
    end
  end
end
