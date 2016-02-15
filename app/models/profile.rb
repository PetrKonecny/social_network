class Profile < ActiveRecord::Base
  belongs_to :user, inverse_of: :profile
  has_attached_file :profile_picture, styles: { medium: "200x200#", small: "100x100#", thumb: "50x50#" }, default_url: "http://placehold.it/50x50"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\Z/
  groupify :group_member
  groupify :named_group_member
  validates :name, :surname, presence: true
  validates :age, numericality: {greater_than: 0}, presence: true


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
