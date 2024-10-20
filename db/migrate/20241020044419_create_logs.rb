class CreateLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :logs do |t|
      t.integer :status
      t.string :response

      t.timestamps
    end
  end
end
