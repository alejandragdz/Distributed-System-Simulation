class Log < ApplicationRecord
	belongs_to :node, optional: true
  	belongs_to :sender, class_name: "Node"

  	scope :leader_logs, -> (leader) {where.not(node_id: leader)}
  	scope :follower_logs, -> (leader) {where(node_id: leader)}

	OK  = 0
	ERR = 1

	REQUEST_VOTE = 2
	VOTE = 3

	def self.createLog(status, message, node_id)
		@log = self.create(status: status, response: message, node_id: node_id)
		@log.node.can_be_candidate?
	end
end
