class AddDateToMigrates < ActiveRecord::Migration
  def change
    add_column :migrates, :trans_date, :date
  end
end
