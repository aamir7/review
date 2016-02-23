class MemberAbility < Ability

  def initialize(user)
    can :read,  User
    can :follow, User, followed?: false
    can :unfollow, User, followed?: true
    can [:followers, :following], User, id: user.id
      
    can :read,  [Micropost, Comment]
    can [:destroy],  Comment, user_id: user.id
    can [:create, :destroy],  Micropost, user_id: user.id
    can :create, Comment, micropost: { user_id: user.following_ids << user.id }
  end
end