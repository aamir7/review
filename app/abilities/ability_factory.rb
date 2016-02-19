class AbilityFactory
 
  def self.build_ability_for(user)
    # Anonymous users don't have access to anything
    return if user.nil?
    
    case user.role.to_sym
    when :admin
      AdminAbility.new(user)
    when :member
      MemberAbility.new(user)
    else
      raise Errors::FlitterError.new("Unknown role passed through: #{user.role}")
    end
  end
end