class Reaction < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  enum reaction_type: [:like, :dislike]
  belongs_to :user
  belongs_to :rateable, polymorphic: true
end
