class License < ActiveRecord::Base
  belongs_to :users
  belongs_to :license_type
end
