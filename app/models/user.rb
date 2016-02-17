class User < ActiveRecord::Base
  has_friendship
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, inverse_of: :user
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :conversations, :foreign_key => :sender_id
  has_many :albums, dependent: :destroy
  has_many :images, through: :albums, dependent: :destroy

  include PublicActivity::Model

  accepts_nested_attributes_for :profile
  validates_associated :profile

  def get_reaction_to_rateable (rateable)
    reaction = self.reactions.select{|obj| obj.rateable.eql?(rateable)}.first
    reaction.reaction_type unless reaction.nil?
  end

  def friends_and_mine_ids
    self.friends.collect { |x| x.id } << self.id
  end

  def common_friends (friend)
    self.friends & friend.friends
  end

  def is_friend?(friend)
    friends.include?(friend)
  end

  def set_default_role
    self.role ||= :user
  end

end
