class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      can :read, :show_hr_forms, id:user.id
      cannot [:update], Payroll
    else
      #can :show_all_timesheets, Timesheet
      #users can read their own timesheets
      can :show_latest, Timesheet
      can :submit, Timesheet, user_id: user.id
      # can :submit, Timesheet do |timesheet|
      #   eval("timesheet.created? && timesheet.payroll.ended? && timesheet.user_id == user.id")
      # end

      user.role.permissions.each do |permission|
        can permission.action_name.to_sym, permission.object_type.constantize do
          eval(permission.conditions) if permission.conditions
        end
      #   if permission.action_name.end_with? "_self_only"
      #     action = permission.action_name.split("_self_only")[0]
      #     if permission.object_type == user.class.name
      #       can action.to_sym, permission.object_type.constantize, id: user.id
      #     elsif permission.object_type.constantize.attribute_names.include? "user_id"
      #       can action.to_sym, permission.object_type.constantize, user_id: user.id
      #     elsif user.attribute_names.include? permission.object_type.underscore << "_id"
      #       can action.to_sym, permission.object_type.constantize do |object|
      #         object.id == eval("user.#{permission.object_type.underscore << '_id'}")
      #       end
      #     elsif permission.object_type.constantize.reflect_on_all_associations(:has_many).select{|i| i.name == permission.object_type.to_sym}.first
      #       can action.to_sym, permission.object_type.constantize do |object|
      #         eval("user.#{permission.object_type.underscore.pluralize}.select{|i| i == object}")
      #       end
      #     end
      #   else
      #   end
      end
    end
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
