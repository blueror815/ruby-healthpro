class UserDocument < ActiveRecord::Base
  belongs_to :user
  belongs_to :document_type

  has_attached_file :attached_document
  validates_attachment_content_type :attached_document, content_type: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/pdf', /\Aimage\/.*\Z/]
end
