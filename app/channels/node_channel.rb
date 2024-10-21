class NodeChannel < ApplicationCable::Channel
	def subscribed
		stream_from "node_#{params[:room]}"
	end
end