class Status < ActiveRecord::Base
  belongs_to :user
  has_many :reactions, as: :rateable
  has_many :comments, as: :commentable

  def get_number_of_likes
    self.reactions.select{|obj| obj.reaction_type.eql?("like")}.count
  end

  def get_number_of_dislikes
    self.reactions.select{|obj| obj.reaction_type.eql?("dislike")}.count
  end

end
