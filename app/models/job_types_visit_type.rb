class JobTypesVisitType < ActiveRecord::Base
  # associations
  belongs_to :job_type
  belongs_to :visit_type
end
