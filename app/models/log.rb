class Log < ApplicationRecord
	belongs_to :node

	def self.createLog(message, node_id)
		self.create(
			status: 0,
			response: message,
			node_id: node_id)
	end
end
