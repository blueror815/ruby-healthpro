class FormCategory < ActiveRecord::Base
  # validations
  validates :name, presence: true, length: { maximum: 60 }

  # associations
  has_many :custom_forms, class_name: 'CustomForms::CustomForm'
  self.table_name = 'form_categories'

  # callbacks
  before_destroy :has_no_forms?

  def self.custom_forms_count
    FormCategory.joins('RIGHT OUTER JOIN custom_forms ON form_categories.id = custom_forms.form_category_id').group('form_categories.name').count
  end

  # check if category has no forms
  def has_no_forms?
    custom_forms.empty?
  end
end
