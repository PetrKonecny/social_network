class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :like, :dislike, to: :rate
    alias_action :friend_accept, :friend_decline, :to => :requests

    can :crud, User, user_id: user.id

    can :crud, Album, user_id: user.id
    can :read, Album do |album|
      album.user.is_friend?(user)
    end

    can :rate, Image do |image|
      user.get_reaction_to_rateable(image).nil?
    end
    can [:read,:destroy], Image do |image|
      image.album.user.eql?(user)
    end
    can :read, Image do |image|
      image.album.user.is_friend?(user)
    end

    can :crud, Profile, user_id: user.id
    can :requests, Profile, user_id: user.id
    can :read, Profile
    can :read_full, Profile do |profile|
      profile.user.friends.include?(user) || profile.user.eql?(user)
    end
    can :friend, Profile do |profile|
      profile.user.friends.exclude?(user)
    end
    can :unfriend, Profile do |profile|
      profile.user.friends.include?(user)
    end

    can :crud, Status, user_id: user.id
    can :read, Status do |status|
      status.user.is_friend?(user)
    end
    can :rate, Status do |status|
      user.get_reaction_to_rateable(status).nil?
    end

    can :crud, Comment, user_id: user.id
    can :read, Comment
    can :rate, Comment do |comment|
      user.get_reaction_to_rateable(comment).nil?
    end

    can [:crud, :insert_user_to_group, :remove_user_from_group], Group do |group|
      user.profile.in_group?(group, as: 'admin')
    end
    can [:read, :create_status], Group do |group|
      user.profile.in_group?(group)
    end
    can :add_to_group, Group do |group|
      group.members.exclude?(user.profile) && group.type_group.eql?("public")
    end
    can :create, Group
    
    can [:show,:update], Conversation do |conversation|
      conversation.sender.eql?(user) || conversation.recipient.eql?(user)
    end
    can :create, Conversation



    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
