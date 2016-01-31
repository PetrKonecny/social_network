class Image < ActiveRecord::Base
  belongs_to :album
  has_attached_file :image, styles: {thumb: "200x200#", large: "900x900>" }
  do_not_validate_attachment_file_type :image
  has_many :reactions, as: :rateable
  has_many :comments, as: :commentable


  def next
    album.images.where("id > ?", id).first
  end

  def prev
    album.images.where("id < ?", id).last
  end

  def get_number_of_likes
    self.reactions.select{|obj| obj.reaction_type.eql?("like")}.count
  end

  def get_number_of_dislikes
    self.reactions.select{|obj| obj.reaction_type.eql?("dislike")}.count
  end

  def user
    self.album.user
  end

end
