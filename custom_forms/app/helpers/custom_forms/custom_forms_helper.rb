module CustomForms
  module CustomFormsHelper
    def models_names
      models = Dir["#{Rails.root}/app/models/*.rb"].map do |f|
        f.chomp('.rb').camelize.demodulize
      end
    end

    def custom_forms_names
      CustomForms::CustomForm.all.map(&:title)
    end
  end
end
