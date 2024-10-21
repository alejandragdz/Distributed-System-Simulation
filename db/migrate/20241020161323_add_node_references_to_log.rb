class AddNodeReferencesToLog < ActiveRecord::Migration[7.2]
  def change
    add_reference :logs, :node, null: true, foreign_key: true
  end
end
