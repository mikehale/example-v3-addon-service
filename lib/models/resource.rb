class Resource < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers
  plugin :paranoid, enable_default_scope: true, soft_delete_on_destroy: true

  def validate
    super
    validates_presence [:heroku_uuid, :plan, :name, :region, :callback_url]
    validates_unique :heroku_uuid
  end
end
