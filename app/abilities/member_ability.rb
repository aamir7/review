class MemberAbility < Ability

  def initialize(user)
    can [:read, :follow, :unfollow],  User
    can [:followers, :following], User, id: user.id
      
    can :read,  [Micropost, Comment]
    can [:create, :destroy],  Comment, user_id: user.id
    can [:create, :destroy],  Micropost, user_id: user.id
  end
end