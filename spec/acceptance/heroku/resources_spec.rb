require "spec_helper"

RSpec.describe Endpoints::Heroku::Resources do
  include Committee::Test::Methods
  include Rack::Test::Methods

  def app
    Routes
  end

  let(:resource_attributes) { Fabricate.attributes_for(:resource) }
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

  before do
    authorize ENV['HEROKU_USERNAME'], ENV['HEROKU_PASSWORD']
    header "Content-Type", "application/json"
    header "Accept", "application/*+json; version=3"
  end

  describe "POST /heroku/resources" do
    let(:last_json) { MultiJson.decode(last_response.body) }

    context "with an incorrect accept header" do
      before do
        header "Accept", nil
      end

      it "responds 404" do
        run
        expect(last_response.status).to eq(404)
      end
    end

    it "responds 202" do
      run
      expect(last_response.status).to eq(202)
    end

    it "returns the resource id" do
      run
      expect(Resource[heroku_uuid: last_json['id']]).not_to be_nil
    end

    it "does not return config" do
      run
      expect(last_json['config']).to be_nil
    end

    def run
      post "/heroku/resources", MultiJson.encode(params)
    end
  end

  describe "PUT /heroku/resources/:id" do
    let!(:resource) { Fabricate(:resource, plan: "starter") }
    let(:new_plan) { "advanced" }

    context "with an incorrect accept header" do
      before do
        header "Accept", nil
      end

      it "responds 404" do
        run
        expect(last_response.status).to eq(404)
      end
    end

    it "responds 200" do
      run
      expect(last_response.status).to eq(200)
    end

    it "updates the resource plan" do
      run
      expect(Resource[uuid: resource.uuid].plan).to eq(new_plan)
    end

    def run
      put "/heroku/resources/#{resource.heroku_uuid}", MultiJson.encode(plan: new_plan)
    end

  end

  describe "DELETE /heroku/resources/:id" do
    let!(:resource) { Fabricate(:resource) }

    context "with an incorrect accept header" do
      before do
        header "Accept", nil
      end

      it "responds 404" do
        run
        expect(last_response.status).to eq(404)
      end
    end

    it "responds 204" do
      run
      expect(last_response.status).to eq(204)
    end

    it "destroys the resource" do
      run
      expect(Resource[heroku_uuid: resource.heroku_uuid]).to be_nil
    end

    def run
      delete "/heroku/resources/#{resource.heroku_uuid}"
    end
  end

end
