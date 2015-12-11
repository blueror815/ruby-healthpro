class LicenseType < ActiveRecord::Base
  belongs_to :job_type
  has_many :license
end
