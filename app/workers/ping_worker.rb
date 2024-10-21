require 'net/http'
class PingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :ping

  def perform(*args)
    puts "_______________________SEND ACTIVE TO FOLLOWERS_______________________"
    @leader = Node.leader
    @followers = Node.followers

    @followers.each do |follower|
      if @leader.active
        Log.createLog(Log::OK,"Active leader Node#{@leader.id}", follower.id)
      else
        Log.createLog(Log::ERR,"Leader not fount", follower.id)
      end
    end
  end
end