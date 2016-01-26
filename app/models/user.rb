class User < ActiveRecord::Base
  has_friendship
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile
  before_create :build_profile
  has_many :reactions
  has_many :comments
  has_many :statuses
  has_many :conversations, :foreign_key => :sender_id



  def get_reaction_to_rateable (rateable)
    reaction = self.reactions.select{|obj| obj.rateable.eql?(rateable)}.first
    reaction.reaction_type unless reaction.nil?
  end
end
