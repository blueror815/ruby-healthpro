module CustomForms
  class CustomForm < ActiveRecord::Base
    # set table name as it's different than conventional name
    self.table_name = 'custom_forms'

    belongs_to :form_category
    has_many :form_data
    has_many :form_sections, dependent: :destroy

    # callbacks
    before_destroy :is_deletion_banned?
    before_destroy :has_form_data_instances?

    # TODO: ifield type
    Type = %w[text integer text_area select select(associative_value) select(associative_value_for_custom_form) date file expirable_file boolean]

    validates_associated :form_category
    validates :title, presence: true
    validates :title, length: { maximum: 60 }
    validates :title, uniqueness: { case_sensitive: false }
    validates :form_sections, length: { minimum: 1 }

    accepts_nested_attributes_for :form_sections, allow_destroy: true

    def remove_deleted_fields_from_instances(fields_ids)
      self.form_data.each do |form_datum|
        form_datum.delete_instances_fields(fields_ids)
      end
    end

    #get custom form basic field types 
    def basic_field_types
      fields = ['boolean', 'date_interval', 'date', 'expirable_file', 'file']
      custom_form_fields = self.form_sections.map(&:section_fields).flatten.map(&:field_type).map(&:field_type).uniq
      custom_form_fields << 'date_interval' if custom_form_fields.include? 'date'
      #remove fields not in report
      custom_form_fields.reject!{|f| !fields.include?(f)}
      custom_form_fields
    end

    private
      # check if it has any form data instances
      def has_form_data_instances?
        unless form_data.empty?
          errors.add(title, 'has some created forms')
          return false
        end
      end

      def is_deletion_banned?
        # need to refactor this and make flag to mark the form better than checking on id
        if deletable == false
          errors.add(title, 'is not deletable')
          return false
        end
      end

      def section_title_presence
        sections.each do |_k, v|
          errors.add(:section_title, "One of your section's name is empty") if v['title'].empty?
        end
      end

      # validates fields names uniquenss per seciton
      def fields_names_uniquenss
        sections.each do |_k, v|
          if v['fields']
            if v['fields'].values.map { |i| i.values.first }.uniq.size != v['fields'].values.map { |i| i.values.first }.size
              errors.add(:duplicated_field_name, 'duplicated for the same seciton')
            end
          end
        end
      end

      # validates fields names presence
      def fields_presence
        sections.each do |_k, v|
          if v['fields']
            v['fields'].each do |_key, value|
              if value['name'].empty?
                errors.add(:field_name, "One of your field's name is empty")
              end
            end
          else
            errors.add(:empty_section, 'One of your sections has no fields')
          end
        end
      end
  end
end
