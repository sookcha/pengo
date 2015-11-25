class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.datetime :trans_date
      t.string :account
      t.string :type
      t.integer :amount
      t.integer :balance
      t.string :store
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
