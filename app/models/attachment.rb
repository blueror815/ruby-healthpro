class Attachment < ActiveRecord::Base
  # associations
  belongs_to :form_datum, class_name: 'CustomForms::FormDatum'
  belongs_to :section_field, class_name: 'CustomForms::SectionField'

  has_attached_file :file, styles: { medium: '300x300#', thumb: '100x100#' }, default_url: 'placeholder.jpg'

  # validations
  validates_attachment_content_type :file, content_type: %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)
  # validates :form_datum_id, uniqueness: { scope: :form_datum_id }
  validates :expiration_date, presence: true, if: :expirable_file?

  private
    def expirable_file?
      self.file_file_name && self.section_field.field_type.field_type == 'expirable_file'
    end
end
