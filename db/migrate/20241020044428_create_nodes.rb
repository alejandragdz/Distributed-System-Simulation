class CreateNodes < ActiveRecord::Migration[7.2]
  def change
    create_table :nodes do |t|
      t.integer :status
      t.references :log, null: true, foreign_key: true

      t.timestamps
    end
  end
end
