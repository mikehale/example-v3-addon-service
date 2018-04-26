require "spec_helper"

RSpec.describe Resource do
  let(:resource) { described_class.new }

  it "must have a heroku_uuid" do
    resource.heroku_uuid = nil
    expect(resource).not_to be_valid
    expect(resource.errors).to have_key(:heroku_uuid)
  end

  it "must have a unqiue heroku_uuid" do
    existing = Fabricate :resource
    resource = Fabricate.build(:resource, heroku_uuid: existing.heroku_uuid)

    expect(resource).not_to be_valid
    expect(resource.errors[:heroku_uuid]).to include("is already taken")
  end

  it "must have a plan" do
    resource.plan = nil
    expect(resource).not_to be_valid
    expect(resource.errors).to have_key(:plan)
  end

  it "must have a region" do
    resource.region = nil
    expect(resource).not_to be_valid
    expect(resource.errors).to have_key(:region)
  end

  it "must have a callback_url" do
    resource.callback_url = nil
    expect(resource).not_to be_valid
    expect(resource.errors).to have_key(:callback_url)
  end

end
