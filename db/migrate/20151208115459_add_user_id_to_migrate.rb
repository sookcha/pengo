class AddUserIdToMigrate < ActiveRecord::Migration
  def change
    add_column :migrates, :user_id, :integer
  end
end
