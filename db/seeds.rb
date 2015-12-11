%w(user admin hr supervisor office_employee executive finance_admin).each do |role|
  Role.where(name: role, short_name: role).first_or_create
end

job_type = JobType.where(title: 'default', job_class: 'default').first_or_create
[['admin@prohealth.com', '123456789', 2, 'admin'], ['hr@prohealth.com', '123456789', 3, 'hr'], ['supervisor@prohealth.com', '123456789', 4, 'supervisor'], ['office_employee@prohealth.com', '123456789', 5, 'office_employee'], ['executive@prohealth.com', '123456789', 6, 'executive']].each do |email, password, role, display_name|
  user = User.where(email: email).first
  unless user
    User.create(email: email, password: password, role_id: role, job_type_id: job_type.id, display_name: display_name)
  end
end

%w(User Patient Visit Hour).each do |object_type|
  %w(edit administrate).each do |action_name|
   Permission.where(object_type: object_type, action_name: action_name).first_or_create
  end
end

Permission.where(object_type: 'Patient', action_name: 'view').first_or_create

Permission.where(object_type: 'User', action_name: 'manage_payments').first_or_create

%w(administrate view_all admit pay).each do |action_name|
 Permission.where(object_type: 'Timesheet', action_name: action_name).first_or_create
end

%w(administrate view_all edit).each do |action_name|
 Permission.where(object_type: 'Visit', action_name: action_name).first_or_create
end

%w(administrate view edit).each do |action_name|
 Permission.where(object_type: 'Bill', action_name: action_name).first_or_create
end

AdminConfiguration.where(title: 'payroll').first_or_create(configurations: {"period"=>{"days"=>"14", "hours"=>"3"},
    "admission_allowance"=>{"days"=>"2", "hours"=>"3"},
    "submission_allowance"=>{"days"=>"1", "hours"=>"3"}})

permissions = {}
Role.user_roles.each do |user_role|
  permissions[user_role] = {}
  User.user_abilities.each do |user_ability|
    permissions[user_role][user_ability] = '1'
  end
end

ClaimType.where(name: 'Hospice').first_or_create(description: 'Hospice description', monthly_paid: true)
ClaimType.where(name: 'Hospice R&B').first_or_create(description: 'Hospice R&B description', monthly_paid: true)

[ ['first_name', 'text'], ['last_name', 'text'], ['middle_name', 'text'],
  ['birth_date', 'date'], ['social_security', 'text', '999-99-9999'],
  ['phone', 'text', '999-999-9999'], ['address', 'text'],
  ['address2', 'text'], ['fax', 'text'], ['city', 'text'], ['zipcode', 'text'],
  ['emergency_contact_name', 'text'], ['title', 'text'], ['status', 'text'],
  ['state', 'text'], ['color', 'text'], ['code', 'text'], ['caregiver_code', 'text'],
  ['user_type', 'text'], ['agency_short', 'text'], ['on_call', 'boolean'],
  ['hire_date', 'date'], ['departure_date', 'date'], ['resume', 'file'], 
  ['employment_application', 'file'], ['background_check', 'file'],
  ['refrences', 'file'], ['offer_letter', 'file'], ['tb_expiration', 'expirable_file'],
  ['signed_job_description', 'file'], ['confidentiality_agreement', 'file'],
  ['reporting_of_abuse', 'file'], ['oriantation_checklist', 'file'],
  ['w_forms', 'file'], ['ee_acknowledgement', 'file'],
  ['joing_comission', 'file'], ['clinician_bag_agreement', 'file'],
  ['laptop_user_agreement', 'file'],['physical_exam_expiration', 'expirable_file'],
  ['chest_x_ray_expiration', 'expirable_file'], ['drug_screen_expiration', 'expirable_file'],
  ['mmr_expration', 'expirable_file'], ['varicella_expiration', 'expirable_file'],
  ['hep_expiration', 'expirable_file'], ['influenza_expiration', 'expirable_file'],
  ['driving_license_expiration', 'expirable_file'], ['cpr_expiration', 'expirable_file'], 
  ['profissional_license_expiration', 'expirable_file'], ['auto_insurance_expiration', 'expirable_file'],
  ['laptop_serial_number', 'expirable_file'] ,['laptop_type', 'expirable_file']].each do |name, field_type, input_mask|
    CustomForms::FieldType.where(name: name, field_type: field_type, input_mask: input_mask).first_or_create
end

['Full Time', 'Weekend', 'Weekday', 'AM', 'PM'].each do |name|
  Availability.where(name: name).first_or_create
end

hr_category = FormCategory.where(name: 'HR').first_or_create
patient_category = FormCategory.where(name: 'Patient').first_or_create
visits_category = FormCategory.where(name: 'visits').first_or_create

hr_form = CustomForms::CustomForm.find_by(title: 'HR Form')
field_types = CustomForms::FieldType.all
unless hr_form
  CustomForms::CustomForm.create(
    title: 'HR Form',
    deletable: false,
    permissions: permissions,
    form_category_id: hr_category.id,
    form_sections_attributes: {
      '0':{
        title: 'Basic Information',
        permissions: permissions,
        section_fields_attributes: {
          '0': {
            field_type_id: field_types.detect{ |i| i.name == 'first_name' }.id,
            field_alias: field_types.detect{ |i| i.name == 'first_name' }.name.humanize
          },
          '1': {
            field_type_id: field_types.detect{ |i| i.name == 'last_name' }.id,
            field_alias: field_types.detect{ |i| i.name == 'last_name' }.name.humanize
          },
          '2': {
            field_type_id: field_types.detect{ |i| i.name == 'middle_name' }.id,
            field_alias: field_types.detect{ |i| i.name == 'middle_name' }.name.humanize
          },
          '4': {
            field_type_id: field_types.detect{ |i| i.name == 'birth_date' }.id,
            field_alias: field_types.detect{ |i| i.name == 'birth_date' }.name.humanize
          },
          '5': {
            field_type_id: field_types.detect{ |i| i.name == 'social_security' }.id,
            field_alias: field_types.detect{ |i| i.name == 'social_security' }.name.humanize
          }
        }
      },
      '1':{
        title: 'Contact Information',
        permissions: permissions,
        section_fields_attributes: {
          '0': {
            field_type_id: field_types.detect{ |i| i.name == 'phone' }.id,
            field_alias: field_types.detect{ |i| i.name == 'phone' }.name.humanize,
            index_display: true
          },
          '1': {
            field_type_id: field_types.detect{ |i| i.name == 'phone' }.id,
            field_alias: 'cell_phone'.humanize,
            index_display: true
          },
          '2': {
            field_type_id: field_types.detect{ |i| i.name == 'address' }.id,
            field_alias: field_types.detect{ |i| i.name == 'address' }.name.humanize
          },
          '3': {
            field_type_id: field_types.detect{ |i| i.name == 'address2' }.id,
            field_alias: field_types.detect{ |i| i.name == 'address2' }.name.humanize
          },
          '4': {
            field_type_id: field_types.detect{ |i| i.name == 'fax' }.id,
            field_alias: field_types.detect{ |i| i.name == 'fax' }.name.humanize
          },
          '5': {
            field_type_id: field_types.detect{ |i| i.name == 'city' }.id,
            field_alias: field_types.detect{ |i| i.name == 'city' }.name.humanize
          },
          '6': {
            field_type_id: field_types.detect{ |i| i.name == 'zipcode' }.id,
            field_alias: field_types.detect{ |i| i.name == 'zipcode' }.name.humanize
          },
          '7': {
            field_type_id: field_types.detect{ |i| i.name == 'emergency_contact_name' }.id,
            field_alias: field_types.detect{ |i| i.name == 'emergency_contact_name' }.name.humanize
          },
          '8': {
            field_type_id: field_types.detect{ |i| i.name == 'phone' }.id,
            field_alias: 'emergency_phone'.humanize
          },
          '9': {
            field_type_id: field_types.detect{ |i| i.name == 'phone' }.id,
            field_alias: 'emergency_alternate_phone'.humanize
          }
        }
      },
      '2':{
        title: 'Additional Information',
        permissions: permissions,
        section_fields_attributes: {
          '1': {
            field_type_id: field_types.detect{ |i| i.name == 'title' }.id,
            field_alias: field_types.detect{ |i| i.name == 'title' }.name.humanize
          },
          '': {
            field_type_id: field_types.detect{ |i| i.name == 'status' }.id,
            field_alias: field_types.detect{ |i| i.name == 'status' }.name.humanize
          },
          '2': {
            field_type_id: field_types.detect{ |i| i.name == 'state' }.id,
            field_alias: field_types.detect{ |i| i.name == 'state' }.name.humanize
          },
          '3': {
            field_type_id: field_types.detect{ |i| i.name == 'color' }.id,
            field_alias: field_types.detect{ |i| i.name == 'color' }.name.humanize
          },
          '4': {
            field_type_id: field_types.detect{ |i| i.name == 'code' }.id,
            field_alias: field_types.detect{ |i| i.name == 'code' }.name.humanize
          },
          '5': {
            field_type_id: field_types.detect{ |i| i.name == 'caregiver_code' }.id,
            field_alias: field_types.detect{ |i| i.name == 'caregiver_code' }.name.humanize
          },
          '6': {
            field_type_id: field_types.detect{ |i| i.name == 'user_type' }.id,
            field_alias: field_types.detect{ |i| i.name == 'user_type' }.name.humanize
          },
          '7': {
            field_type_id: field_types.detect{ |i| i.name == 'agency_short' }.id,
            field_alias: field_types.detect{ |i| i.name == 'agency_short' }.name.humanize
          },
          '8': {
            field_type_id: field_types.detect{ |i| i.name == 'on_call' }.id,
            field_alias: field_types.detect{ |i| i.name == 'on_call' }.name.humanize
          },
          '9': {
            field_type_id: field_types.detect{ |i| i.name == 'hire_date' }.id,
            field_alias: field_types.detect{ |i| i.name == 'hire_date' }.name.humanize
          },
          '10': {
            field_type_id: field_types.detect{ |i| i.name == 'departure_date' }.id,
            field_alias: field_types.detect{ |i| i.name == 'departure_date' }.name.humanize
          }
        }
      }
    }
  )
end

checklist_form = CustomForms::CustomForm.find_by(title: 'checklist')
unless checklist_form
  CustomForms::CustomForm.create(
    title: 'checklist',
    permissions: permissions,
    form_category_id: hr_category.id,
    form_sections_attributes: {
      '0':{
        title: 'profile completion',
        permissions: permissions,
        section_fields_attributes: {
          '0': {
            field_type_id: field_types.detect{ |i| i.name == 'resume' }.id,
            field_alias: field_types.detect{ |i| i.name == 'resume' }.name.humanize
           },
          '1': {
            field_type_id: field_types.detect{ |i| i.name == 'employment_application' }.id,
            field_alias: field_types.detect{ |i| i.name == 'employment_application' }.name.humanize
           },
          '2': {
            field_type_id: field_types.detect{ |i| i.name == 'background_check' }.id,
            field_alias: field_types.detect{ |i| i.name == 'background_check' }.name.humanize
           },
          '3': {
            field_type_id: field_types.detect{ |i| i.name == 'refrences' }.id,
            field_alias: field_types.detect{ |i| i.name == 'refrences' }.name.humanize
           },
          '4': {
            field_type_id: field_types.detect{ |i| i.name == 'offer_letter' }.id,
            field_alias: field_types.detect{ |i| i.name == 'offer_letter' }.name.humanize
           },
          '5': {
            field_type_id: field_types.detect{ |i| i.name == 'signed_job_description' }.id,
            field_alias: field_types.detect{ |i| i.name == 'signed_job_description' }.name.humanize
           },
          '6': {
            field_type_id: field_types.detect{ |i| i.name == 'confidentiality_agreement' }.id,
            field_alias: field_types.detect{ |i| i.name == 'confidentiality_agreement' }.name.humanize
           },
          '7': {
            field_type_id: field_types.detect{ |i| i.name == 'reporting_of_abuse' }.id,
            field_alias: field_types.detect{ |i| i.name == 'reporting_of_abuse' }.name.humanize
           },
          '8': {
            field_type_id: field_types.detect{ |i| i.name == 'oriantation_checklist' }.id,
            field_alias: field_types.detect{ |i| i.name == 'oriantation_checklist' }.name.humanize
           },
          '9': {
            field_type_id: field_types.detect{ |i| i.name == 'w_forms' }.id,
            field_alias: field_types.detect{ |i| i.name == 'w_forms' }.name.humanize
           },
          '10': {
            field_type_id: field_types.detect{ |i| i.name == 'ee_acknowledgement' }.id,
            field_alias: field_types.detect{ |i| i.name == 'ee_acknowledgement' }.name.humanize
           },
          '11': {
            field_type_id: field_types.detect{ |i| i.name == 'joing_comission' }.id,
            field_alias: field_types.detect{ |i| i.name == 'joing_comission' }.name.humanize
           },
          '12': {
            field_type_id: field_types.detect{ |i| i.name == 'clinician_bag_agreement' }.id,
            field_alias: field_types.detect{ |i| i.name == 'clinician_bag_agreement' }.name.humanize
           },
          '13': { 
            field_type_id: field_types.detect{ |i| i.name == 'laptop_user_agreement' }.id,
            field_alias: field_types.detect{ |i| i.name == 'laptop_user_agreement' }.name.humanize
          },
        }
      }
    }
  )
end


license_expiration_dates_form = CustomForms::CustomForm.find_by(title: 'license expiration dates')
unless license_expiration_dates_form
  CustomForms::CustomForm.create(
    title: 'license expiration dates',
    permissions: permissions,
    form_category_id: hr_category.id,
    form_sections_attributes: {
      '0':{
        title: 'expiration dates',
        permissions: permissions,
        section_fields_attributes: {
          '0': {
            field_type_id: field_types.detect{ |i| i.name == 'physical_exam_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'physical_exam_expiration' }.name.humanize
           },
          '1': {
            field_type_id: field_types.detect{ |i| i.name == 'tb_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'tb_expiration' }.name.humanize
           },
          '2': {
            field_type_id: field_types.detect{ |i| i.name == 'chest_x_ray_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'chest_x_ray_expiration' }.name.humanize
           },
          '3': {
            field_type_id: field_types.detect{ |i| i.name == 'drug_screen_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'drug_screen_expiration' }.name.humanize
           },
          '4': {
            field_type_id: field_types.detect{ |i| i.name == 'mmr_expration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'mmr_expration' }.name.humanize
           },
          '5': {
            field_type_id: field_types.detect{ |i| i.name == 'varicella_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'varicella_expiration' }.name.humanize
           },
          '6': {
            field_type_id: field_types.detect{ |i| i.name == 'hep_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'hep_expiration' }.name.humanize
           },
          '7': {
            field_type_id: field_types.detect{ |i| i.name == 'influenza_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'influenza_expiration' }.name.humanize
           },
          '8': {
            field_type_id: field_types.detect{ |i| i.name == 'driving_license_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'driving_license_expiration' }.name.humanize
           },
          '9': {
            field_type_id: field_types.detect{ |i| i.name == 'profissional_license_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'profissional_license_expiration' }.name.humanize
           },
          '10': {
            field_type_id: field_types.detect{ |i| i.name == 'cpr_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'cpr_expiration' }.name.humanize
           },
          '11': {
            field_type_id: field_types.detect{ |i| i.name == 'auto_insurance_expiration' }.id,
            field_alias: field_types.detect{ |i| i.name == 'auto_insurance_expiration' }.name.humanize
           },
          '12': {
            field_type_id: field_types.detect{ |i| i.name == 'laptop_type' }.id,
            field_alias: field_types.detect{ |i| i.name == 'laptop_type' }.name.humanize
           },
          '13': {
            field_type_id: field_types.detect{ |i| i.name == 'laptop_serial_number' }.id,
            field_alias: field_types.detect{ |i| i.name == 'laptop_serial_number' }.name.humanize
           },
        }
      }
    }
  )
end

unless Report.find_by(name: 'Licenses Expired')
  Report.create(name: 'Licenses Expired', 
               custom_form_id: CustomForms::CustomForm.find_by(title: 'license expiration dates').id,
               report_fields_attributes: {
               '0': { field_type: 'expirable_file', field_value: '0', value_options: { "to"=>"", "days"=>"0", "from"=>"" } } })
end

unless Report.find_by(name: 'Licenses Expiring in 30 Days')
  Report.create(name: 'Licenses Expiring in 30 Days', 
               custom_form_id: CustomForms::CustomForm.find_by(title: 'license expiration dates').id,
               report_fields_attributes: {
               '0': { field_type: 'expirable_file', field_value: '0', value_options: { "to"=>"", "days"=>"30", "from"=>"" } } })
end

unless Report.find_by(name: 'Licenses Expiring in 60 Days')
  Report.create(name: 'Licenses Expiring in 60 Days', 
               custom_form_id: CustomForms::CustomForm.find_by(title: 'license expiration dates').id,
               report_fields_attributes: {
               '0': { field_type: 'expirable_file', field_value: '0', value_options: { "to"=>"", "days"=>"60", "from"=>"" } } })
end

unless Report.find_by(name: 'Profile Checklist')
  Report.create(name: 'Profile Checklist', 
               custom_form_id: CustomForms::CustomForm.find_by(title: 'checklist').id,
               report_fields_attributes: {
               '0': { field_type: 'file', field_value: '0', value_options: { "to"=>"", "days"=>"", "from"=>"" } } })
end
