class AddNodeReferenceToLog < ActiveRecord::Migration[7.2]
  def change
    add_column :logs, :sender_id, :integer, null: false
  end
end
