class CreateNodes < ActiveRecord::Migration[7.2]
  def change
    create_table :nodes do |t|
      t.integer :status
      t.integer :active, default: 0

      t.timestamps
    end
  end
end
