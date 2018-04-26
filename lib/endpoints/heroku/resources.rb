module Endpoints
  class Heroku::Resources < Base
    use Middleware::HerokuAuthenticator

    namespace "/heroku/resources" do
      before do
        content_type :json, charset: 'utf-8'
      end

      post do
        resource = Mediators::Resources::Creator.run(
          plan:         body_params['plan'],
          name:         body_params['name'],
          region:       body_params['region'],
          callback_url: body_params['callback_url'],
          heroku_uuid:  body_params['uuid'],
          oauth_grant:  body_params['oauth_grant']
        )

        status 202
        MultiJson.encode(id: resource.heroku_uuid)
      end

      before "/:uuid" do |uuid|
        @resource = Resource[heroku_uuid: uuid]
      end

      put "/:uuid" do
        Mediators::Resources::Updater.run(
          resource: @resource,
          plan: body_params['plan']
        )

        status 200
        MultiJson.encode({})
      end

      delete "/:uuid" do
        if @resource
          Mediators::Resources::Destroyer.run(resource: @resource)
        end
        status 204
      end
    end

  end
end
