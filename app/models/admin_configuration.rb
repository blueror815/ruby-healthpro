class AdminConfiguration < ActiveRecord::Base
  validates :title, uniqueness: true
end
