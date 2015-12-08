class AddAttachmentToMigrate < ActiveRecord::Migration
  def up
    add_attachment :migrates, :receipt
  end

  def down
    remove_attachment :migrates, :receipt
  end
end
