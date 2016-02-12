class Group < ActiveRecord::Base
  groupify :group
  has_many :statuses
  include PublicActivity::Model
end
