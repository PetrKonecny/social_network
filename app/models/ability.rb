class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :like, :dislike, to: :rate
    can :crud, Comment, user_id: user.id
    can :crud, User, user_id: user.id
    can :crud, Profile, user_id: user.id
    can :read, Profile
    can :crud, Status, user_id: user.id
    can :rate, Comment do |comment|
      comment.get_user_reaction(user).nil?
    end
    can :rate, Status do |status|
      status.get_user_reaction(user).nil?
    end



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
