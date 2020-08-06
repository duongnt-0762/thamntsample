class Sach < ApplicationRecord
	validates :ten, presence: true
	validates :nxb, presence: true
	validates :namxb, presence: true
	befor_save :namxuatban
	def namxuatban
			salf.namxb = 2020		
	end
end
