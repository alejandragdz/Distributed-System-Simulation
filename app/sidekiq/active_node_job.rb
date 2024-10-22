class ActiveNodeJob
  include Sidekiq::Job

  def perform(node_id, count)
    begin
      sleep 10

      init_time = Time.now
      @node = Node.find(node_id)
      logs = @node.logs

      if @node.status == Node::LEADER
        puts "IS LEADER"
        @node.notify_all_followers
      elsif @node.status == Node::CANDIDATE
        puts "IS CANDIDATE"
        if logs.present? and logs.last.status == Log::VOTE and @node.status == Node::CANDIDATE
          @node.change_leader
        end
      else
        puts "IS FOLLOWER"
        if logs.present? and logs.last.created_at > (init_time - 20.seconds)
          last_log = logs.last
          if last_log.status == Log::REQUEST_VOTE
            Log.create(
              status: Log::VOTE,
              response: "Node#{last_log.node_id} vote for Node#{last_log.sender_id}",
              node_id: last_log.sender_id,
              sender_id: last_log.node_id)
          end
        else
          @node.requests_votes()
        end
      end
      sleep 10
      ActiveNodeJob.perform_async(node_id, count+1)
    rescue StandardError => e
    end
  end
end
