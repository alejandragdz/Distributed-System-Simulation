class Node < ApplicationRecord
  has_many :logs
  before_save :default_values

  scope :leader, -> {find_by(status: LEADER) }
  scope :followers, -> {where(status: FOLLOWER) }
  scope :candidates, -> {where(status: CANDIDATE) }
  scope :nodes, -> {where(status: [FOLLOWER, CANDIDATE])}
  
  def default_values
    self.status ||= Node.all.empty? ? LEADER : FOLLOWER
    self.active ||= ACTIVE
  end

  LEADER = 1
  CANDIDATE = 2
  FOLLOWER = 3

  ACTIVE = 0
  INACTIVE = 1
  DEAD = 3

  def leader?
    @leader = Node.leader
    return self.id == @leader.id
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
end
