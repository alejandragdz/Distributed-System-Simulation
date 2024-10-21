require 'net/http'
class PingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :ping

  def perform(*args)
    puts "_______________________SEND ACTIVE TO FOLLOWERS_______________________"
    @leader = Node.leader
    @nodes = Node.nodes

    @nodes.each do |node|
      if node.active == Node::ACTIVE
        if @leader.active == Node::ACTIVE
          Log.createLog(Log::OK,"Active leader Node#{@leader.id}", node.id)
        else
          Log.createLog(Log::ERR,"Leader not found", node.id)
        end
      end
    end

    Node.change_leader
  end
end