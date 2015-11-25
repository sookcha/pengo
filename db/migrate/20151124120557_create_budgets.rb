class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.datetime :trans_date
      t.string :trans_account
      t.string :trans_type
      t.integer :trans_amount
      t.integer :trans_balance
      t.string :trans_store
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
