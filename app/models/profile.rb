class Profile < ActiveRecord::Base
  belongs_to :user
  has_attached_file :profile_picture, styles: { medium: "200x200#", thumb: "100x100#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\Z/
  groupify :group_member
  groupify :named_group_member


  def full_name
    "#{self.name} #{self.surname}"
  end

  def self.search(query)
    if query.match(/\s/)
      where("unaccent(lower(name)) || ' ' || unaccent(lower(surname)) like?", "%#{query.unaccent.downcase}%")
    else
      where("unaccent(lower(name)) like ? or unaccent(lower(surname)) like?", "%#{query.unaccent.downcase}%", "%#{query.unaccent.downcase}%")
    end
  end

end
