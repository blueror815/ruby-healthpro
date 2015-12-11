module CustomForms
  class FormDatum < ActiveRecord::Base
    # TODO: we need to a clear definition for vists form datum identification

    # set table name as it's different than conventional name
    self.table_name = 'form_data'

    # validations
    validate :required_fields
    validates :creator_user_id, presence: true

    # callbacks
    after_initialize :initialize_object_data

    # scopes
    # TODO: this need urgently to be fixed
    scope :hr_form, -> { where(custom_form_id: 1) }
    scope :other_than_hr, -> { where.not(custom_form_id: 1) }
    scope :hours, -> { where(custom_form_id: 4) }

    # associations
    has_many :attachments
    has_many :comments, as: :commentable
    belongs_to :custom_form
    belongs_to :user
    belongs_to :patient
    belongs_to :creator, class_name: 'User', foreign_key: 'creator_user_id'

    accepts_nested_attributes_for :attachments

    def delete_instances_fields(deleted_fields)
      deleted_fields.each do |section_id, fields_ids|
        self[:sections_data].except!(fields_ids)
        self.save!
      end
    end
    
    #update_forms with new fields 
    def self.update_forms_with_new_field(custom_form_id, field)
      forms = FormDatum.where(custom_form_id: custom_form_id)
      field_type = field.field_type.field_type
      forms.each do |form|
        if field_type == "boolean"
          form.sections_data["#{field.id}"] = '0'
        elsif field_type == "file"
          form.sections_data["#{field.id}"] = 'file'
        elsif field_type == "expirable_file"
          form.sections_data["#{field.id}"] = 'expirable_file'
        else
          form.sections_data["#{field.id}"] = ''
        end
        form.save!
      end
    end

    private
    def required_fields
      custom_form.form_sections.map(&:section_fields).flatten.each do |field|
        if field.required?
          # here we check that the required field is already exist in the form data -> section fields and check that it's not empty string
          unless sections_data.keys.include?(field.id.to_s) && !sections_data[field.id.to_s].blank?
            errors.add(field.field_type.name, "Can't be blank")
          else
            if sections_data[field.id.to_s] == 'file'
              errors.add(field.field_type.name, "Can't be blank") if attachments.detect{ |i| i.section_field_id == field.id}.file.blank?
            end
          end
        end
      end
    end

    def initialize_object_data
      self.sections_data = {} if sections_data.nil?
    end

  end
end
