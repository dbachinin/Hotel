class ApplicationRecord < ActiveRecord::Base
	has_many :bookings
  self.abstract_class = true
end
