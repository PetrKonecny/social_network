class Profile < ActiveRecord::Base
  belongs_to :user

  groupify :group_member
  groupify :named_group_member


  def full_name
    "#{self.name} #{self.surname}"
  end

end
