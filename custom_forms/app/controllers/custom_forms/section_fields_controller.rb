module CustomForms
  class SectionFieldsController < ApplicationController
    before_filter :set_section_field

    def destroy
      @section_field.destroy
      respond_to do |format|
        format.js { render nothing: true }
      end
    end

    private
      def set_section_field
        @section_field = CustomForms::SectionField.find_by(id: params[:id])
      end
  end
end
