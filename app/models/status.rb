class Status < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :reactions, as: :rateable
  has_many :comments, as: :commentable
  include PublicActivity::Model
  validates :body, presence: true
  tracked owner: Proc.new{ |controller, model| controller.current_user }, only: :create

  def get_number_of_likes
    self.reactions.select{|obj| obj.reaction_type.eql?("like")}.count
  end

  def get_number_of_dislikes
    self.reactions.select{|obj| obj.reaction_type.eql?("dislike")}.count
  end

end
