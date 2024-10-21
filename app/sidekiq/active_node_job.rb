class ActiveNodeJob
  include Sidekiq::Job

  def perform(node_id)
    # Do something
    puts "_______________________NOTIFY NEW NODE_______________________"
    @leader = Node.leader
    Log.createLog(Log::OK, "New node Node#{node_id}", @leader.id) if @leader.present? and @leader.id != node_id
  end
end
