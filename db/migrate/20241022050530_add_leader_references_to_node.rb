class AddLeaderReferencesToNode < ActiveRecord::Migration[7.2]
  def change
    add_column :nodes, :leader_id, :integer, null: true
  end
end
