FactoryGirl.define do
  factory :form_datum, class: CustomForms::FormDatum do
  end

  factory :visit_datum, class: CustomForms::FormDatum do
    # association :custom_form, factory: :visits_custom_form
    # association :user, factory: :visits_custom_form
    # section_fields
    #                   fields_data = {}
    #                   self.custom_form.sections.each do |k, v|
    #                     fields = {}
    #                     v['fields'].values.each do |field|
    #                       fields[field['name']] = ''
    #                     end
    #                     fields_data[k] = fields
    #                   end
    #                   Hash.new(fields_data)
  end
end
