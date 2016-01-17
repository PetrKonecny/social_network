class Reaction < ActiveRecord::Base
  enum reaction_type: [:like, :dislike]
  belongs_to :user
  belongs_to :feelable, polymorphic: true
end
