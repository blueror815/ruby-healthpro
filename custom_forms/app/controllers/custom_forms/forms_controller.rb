module CustomForms
  class FormsController < ApplicationController
    before_action :set_custom_form, only: :show
    before_action :set_user_forms, only: :index

    def index
      @forms = (@forms_to_show + @forms_to_edit + @forms_to_create).uniq
    end

    def show
      @forms_data = current_user.created_form_data.where(custom_form_id: @custom_form.id)
    end

    private
      def set_custom_form
        @custom_form = CustomForms::CustomForm.find(params[:id])
      end

      def can_create_instance(custom_form_id)
        custom_form = CustomForms::CustomForm.find(custom_form_id)
        custom_form.permissions["#{current_user.role.short_name}"]['create'] == '1'
      end

      def can_edit_instance(custom_form_id)
        custom_form = CustomForms::CustomForm.find(custom_form_id)
        custom_form.permissions["#{current_user.role.short_name}"]['edit'] == '1'
      end
      helper_method :can_create_instance, :can_edit_instance
  end
end
