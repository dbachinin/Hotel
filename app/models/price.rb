class Price < ApplicationRecord
	belongs_to :room
	has_many :taryph

end
