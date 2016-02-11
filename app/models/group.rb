class Group < ActiveRecord::Base
  groupify :group
  has_many :statuses
end
