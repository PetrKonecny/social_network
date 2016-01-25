class Profile < ActiveRecord::Base
  belongs_to :user

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
