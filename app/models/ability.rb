class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user (not logged in)

    if user.has_role?(:admin)
      admin_abilities
    else
      user_abilities(user)
    end
  end

  def admin_abilities
    can :manage, :all # Admins can manage all resources
  end

  def user_abilities(user)
    can :read, Post, user_id: user.id # Users can only read their own posts

    can [:create, :update, :destroy], Post, user_id: user.id # Users can CRUD their own posts
  end
end
