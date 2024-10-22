class Node < ApplicationRecord
  has_many :logs
  before_save :default_values
  after_save :init_node

  scope :followers, -> {where(status: FOLLOWER) }
  scope :candidates, -> {where(status: CANDIDATE) }
  scope :nodes, -> {where(status: [FOLLOWER, CANDIDATE])}
  
  def default_values
    self.status ||= FOLLOWER
    self.active ||= ACTIVE
  end

  LEADER = 1
  CANDIDATE = 2
  FOLLOWER = 3

  ACTIVE = 0
  INACTIVE = 1
  DEAD = 3

  def self.leader
    return Node.find_by(status: Node::LEADER)
  end

  def leader?
    return self.status == LEADER
  end

  def is_follower?
    return self.status == FOLLOWER
  end

  def active?
    return self.active == ACTIVE
  end

  def my_logs
    @leader = Node.leader
    return Log.leader_logs(@leader.id) if self.leader?
    return Log.follower_logs(@leader.id)
  end

  def can_be_candidate?
    return unless (self.status == FOLLOWER and self.active?)
    @last_logs = self.logs.last(3)
    if @last_logs.present? and !@last_logs.pluck(:status).include?(Log::OK)
      if self.update(status: Node::CANDIDATE)
        Node.followers.each do |follower|
          Log.createLog(Log::OK,"Node#{self.id} change to candidate", follower.id) if follower.active?
        end
      end
    end
  end

  def self.change_leader
    @leader = Node.leader
    return if @leader.active?
    @new_leader = possible_candidate
    return unless @new_leader.present?
    @leader.update(status: Node::FOLLOWER)
    @new_leader.update(status: Node::LEADER)
    Node.nodes.each do |node|
      Log.createLog(Log::OK,"Node#{@new_leader.id} change to leader", node.id) if node.active?
    end
    Node.candidates.each do |node|
      node.update(status: FOLLOWER)
    end
  end

  def self.possible_candidate
    Node.candidates.order(:created_at).each do |candidate|
      if !candidate.logs.last(5).pluck(:status).include?(Log::OK)
        return candidate
      end
    end
    nil
  end

  def init_node
    ActiveNodeJob.perform_async(self.id, 0)
  end

  # --------

  def requests_votes()
    nodes = Node.nodes
    if nodes.count - 1 > 0
      self.update(status: CANDIDATE)
      Node.nodes.each do |node|
        if node.id != self.id
          Log.create(
            status: Log::REQUEST_VOTE,
            response: "Node#{self.id} requests votes",
            node_id: node.id,
            sender_id: self.id)
        end
      end
      Sidekiq::Queue.all.map(&:clear)
    end
  end

  def change_leader
    puts "akljsbals..djbañdcjañ.jba.csa.CBS.LBCSLBSBL.SA-J-{{SÑODKÑSADMASONÑKSlNSlnlds"
    self.update(status: LEADER)
    Node.candidates.each do |candidate|
      candidate.update(status: FOLLOWER)
    end
  end

  def notify_all_followers
    Node.followers.each do |follower|
      Log.create(
          status: Log::OK,
          response: "Leader Node#{self.id} is active",
          node_id: follower.id,
          sender_id: self.id)
    end
  end
end
