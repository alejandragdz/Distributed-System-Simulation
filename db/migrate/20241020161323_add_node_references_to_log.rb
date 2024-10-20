class AddNodeReferencesToLog < ActiveRecord::Migration[7.2]
  def change
    add_reference :logs, :node, null: false, foreign_key: true
  end
end
