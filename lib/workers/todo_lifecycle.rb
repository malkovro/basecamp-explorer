class TodoLifecycle
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  attribute :name
  attribute :work_started_at
  attribute :released_at
  attribute :release_version
  attribute :pull_requests
end
