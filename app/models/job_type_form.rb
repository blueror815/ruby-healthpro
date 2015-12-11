class JobTypeForm < ActiveRecord::Base
  belongs_to :job_type
  belongs_to :custom_form, class_name: 'CustomForms::CustomForm'
end
