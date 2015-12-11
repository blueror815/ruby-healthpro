module CanCan
  module Ability
    def authorize!(action, subject, *args)
      case action.to_s
        when "show", "index" then action_name = "read"
        when "create", "new" then action_name = "create"
        when "update", "edit" then action_name = "update"
        when "delete", "destroy" then action_name = "destroy"
        else action_name = action.to_s
      end

      # save data to permissions table
      # Permission.create(:object_type => subject.to_s, :action_name => action_name)

      message = nil
      if args.last.kind_of?(Hash) && args.last.has_key?(:message)
        message = args.pop[:message]
      end

      if cannot?(action, subject, *args)
        message ||= unauthorized_message(action, subject)
        raise AccessDenied.new(message, action, subject)
      end
    end
  end
end
