class CreateNodes < ActiveRecord::Migration[7.2]
  def change
    create_table :nodes do |t|
      t.integer :status
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
