class Comment < ActiveRecord::Base
  include PublicActivity::Model
  validates :body, presence: true
  tracked owner: Proc.new{ |controller, model| controller.current_user }, only: :create
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :reactions, as: :rateable

  def get_number_of_likes
    self.reactions.select{|obj| obj.reaction_type.eql?("like")}.count
  end

  def get_number_of_dislikes
    self.reactions.select{|obj| obj.reaction_type.eql?("dislike")}.count
  end

end
