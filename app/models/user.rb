class User < ActiveRecord::Base
  before_create :build_profile
  has_friendship
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile
  has_many :reactions
  has_many :comments
  has_many :statuses
  has_many :conversations, :foreign_key => :sender_id
  has_many :albums

  include PublicActivity::Model

  def get_reaction_to_rateable (rateable)
    reaction = self.reactions.select{|obj| obj.rateable.eql?(rateable)}.first
    reaction.reaction_type unless reaction.nil?
  end

  def friends_and_mine_ids
    self.friends.collect { |x| x.id } << self.id
  end

  def set_default_role
    self.role ||= :user
  end
end
