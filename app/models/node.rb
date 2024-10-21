class Node < ApplicationRecord
  has_many :logs
  before_save :default_values

  scope :leader, -> {find_by(status: LEADER) }
  scope :followers, -> {where(status: FOLLOWER) }
  scope :candidates, -> {where(status: CANDIDATE) }
  scope :nodes, -> {where(status: [FOLLOWER, CANDIDATE])}
  
  def default_values
    self.status ||= Node.all.empty? ? 1 : 3
  end

  LEADER = 1
  CANDIDATE = 2
  FOLLOWER = 3

  def leader?
    @leader = Node.leader
    return self.id == @leader.id
  end

  def my_logs
    @leader = Node.leader
    return Log.leader_logs(@leader.id) if self.leader?
    return Log.follower_logs(@leader.id)
  end
end
