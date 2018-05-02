module ResourceHelper
  def oauth_grant
    value = super
    MultiJson.load(value) if value
  end

  def oauth_grant=(value)
    super(MultiJson.dump(value))
  end

  def oauth_token_data
    value = super
    MultiJson.load(value) if value
  end

  def oauth_token_data=(value)
    super(MultiJson.dump(value))
  end
end

class Resource < Sequel::Model
  include AttrVault
  vault_keyring Config.attr_vault_keyring
  vault_attr :oauth_grant
  vault_attr :oauth_token_data

  prepend ResourceHelper

  plugin :timestamps
  plugin :validation_helpers
  plugin :paranoid, enable_default_scope: true, soft_delete_on_destroy: true

  def validate
    super
    validates_presence [:heroku_uuid, :plan, :name, :region, :callback_url]
    validates_unique :heroku_uuid
  end
end
