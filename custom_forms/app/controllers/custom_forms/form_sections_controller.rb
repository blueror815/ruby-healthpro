module CustomForms
  class FormSectionsController < ApplicationController
    before_filter :set_form_section

    def destroy
      @form_section.destroy
      respond_to do |format|
        format.js { render nothing: true }
      end
    end

    private
      def set_form_section
        @form_section = CustomForms::FormSection.find_by(id: params[:id])
      end
  end
end
