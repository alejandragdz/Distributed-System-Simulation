class HomeController < ApplicationController
  before_action :set_nodes, only: %i[ start_simulation ]

  def index
    @leader = Node.leader
    @nodes  = Node.nodes
    @node   = Node.new
    @logs = Log.all
  end

  def start_simulation
    @nodes.each do |node|
      # ActiveNodeJob.perform_async(node.id, 0)
    end

    respond_to do |format|
      format.html { redirect_to root_url, notice: "Simulation started" }    
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nodes
      @nodes = Node.all
    end
end
