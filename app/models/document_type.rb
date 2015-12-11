class DocumentType < ActiveRecord::Base
  belongs_to :job_type
  has_many :user_documents
end
