class CreateMigrates < ActiveRecord::Migration
  def change
    create_table :migrates do |t|
      t.string :bank
      t.timestamps null: false
    end
  end
end
