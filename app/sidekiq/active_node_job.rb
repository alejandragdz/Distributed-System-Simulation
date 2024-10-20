class ActiveNodeJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
    puts "_______________________SEND ACTIVE TO FOLLOWERS_______________________"
    @leader = Node.leader
    Log.createLog("Active leader Node#{@leader.id}", @leader.id)
  end
end
