class DashboardController < ApplicationController
  def index
    @budget = Budget.where(:user_id => 1)
    
    @totalPay = 0
    @groceries = 0
    
    @budget.each do |b|
      @totalPay += b.trans_amount
      if b.trans_store.include? "마트" or b.trans_store.include? "GS" or b.trans_store.include? "CU"
        @groceries += b.trans_amount
      end
    end
  end
end
