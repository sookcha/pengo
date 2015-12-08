class AddAttachmentAndBankToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :bank, :string
  end
end
