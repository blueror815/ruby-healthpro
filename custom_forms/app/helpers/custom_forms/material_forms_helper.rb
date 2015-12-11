module CustomForms
  module MaterialFormsHelper
    def material_form_text_field form, method, label, options= {}
      material_form_group(label.empty? ? method : label, options) do
        f.text_field method, class: "form-control".contact(options.try("class"))
      end
    end

    def material_text_field object_name, method, options= {}
      material_form_group(method, options) do
        text_field object_name, method, class: "form-control".contact(options.try("class"))
      end
    end


    def material_form_group(label, options = {}, &block)
      content_tag(:div, class: "form-group".concat(options.try(:class))) do
        concat label_tag(label)
        concat capture(&block)
      end
    end
  end
end