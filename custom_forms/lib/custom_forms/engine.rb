module CustomForms
  class Engine < ::Rails::Engine
    isolate_namespace CustomForms
    config.to_prepare do
      ApplicationController.helper(ApplicationHelper)
      ApplicationController.helper(NotificationsHelper)
    end
  end
end
