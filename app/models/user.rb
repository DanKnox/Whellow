class User
  include Mongoid::Document
  include Sorcery::Model
  include Sorcery::Model::Adapters::Mongoid
  authenticates_with_sorcery!

  field :name
  field :email
  field :token
  field :uid
end
