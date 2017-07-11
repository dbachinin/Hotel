class Price < ApplicationRecord
	belongs_to :room, polymorphic: true
	has_many :taryph

end
