class HomeController < ApplicationController
  def index
    @leader = Node.leader
    @nodes  = Node.nodes
    @node   = Node.new
  end
end
