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
end
