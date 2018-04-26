module Mediators::Resources
  class Creator < Mediators::Base
    def initialize(plan:, name:, region:, callback_url:, heroku_uuid:, oauth_grant:)
      self.plan = plan
      self.name = name
      self.region = region
      self.callback_url = callback_url
      self.heroku_uuid = heroku_uuid
      self.oauth_grant = oauth_grant
    end

    def call
      Resource.db.transaction do
        Jobs::ProvisionResource.enqueue(heroku_uuid)
        Resource.create(
          heroku_uuid: heroku_uuid,
          plan: plan,
          name: name,
          region: region,
          callback_url: callback_url,
          oauth_grant: oauth_grant # TODO: encrypt this
        )
      end
    end

    private

    attr_accessor :plan, :name, :region, :callback_url, :heroku_uuid, :oauth_grant
  end
end
