class Album < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  has_many :images, dependent: :destroy
  belongs_to :user

end
