require 'custom_forms/engine'

module CustomForms
  def set_user_forms
    role = current_user.role.short_name
    @forms_to_create = CustomForms::CustomForm.where("permissions -> ? ->> 'create' = '1'", role)
    @forms_to_edit = CustomForms::CustomForm.where("permissions -> ? ->> 'edit' = '1'", role)
    @forms_to_show = CustomForms::CustomForm.where("permissions -> ? ->> 'view' = '1'", role)
  end

  # set action variable to check user authorization for form sections
  def check_user_form_authorization
    @action = if action_name == 'new'
                'create'
              elsif action_name == 'update' || 'destroy'
                'edit'
              else
                action_name
              end
    redirect_to main_app.root_path unless (instance_variable_get "@forms_to_#{@action}").include? @custom_form
  end
end
