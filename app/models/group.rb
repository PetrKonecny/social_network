class Group < ActiveRecord::Base
  groupify :group
  has_many :statuses
  include PublicActivity::Model

  def self.search(search)
    if search
      where('unaccent(lower(name)) like?', "%#{search.unaccent.downcase}%")
    else
      find(:with_member => current_user.profile)
    end
  end
end
