class GroupMembership < ActiveRecord::Base
  groupify :group_membership
  include PublicActivity::Model
  tracked only: :create
end
