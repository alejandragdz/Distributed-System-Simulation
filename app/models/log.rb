class Log < ApplicationRecord
	belongs_to :node, optional: true

  	scope :leader_logs, -> (leader) {where.not(node_id: leader)}
  	scope :follower_logs, -> (leader) {where(node_id: leader)}

	OK  = 0
	ERR = 1

	def self.createLog(status, message, node_id)
		self.create(
			status: status,
			response: message,
			node_id: node_id)
		ActionCable.server.broadcast(
	        "node_1",
	        {
	          action: "updated"
	        }
	    )
	end
end
