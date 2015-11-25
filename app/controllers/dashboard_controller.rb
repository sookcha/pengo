class DashboardController < ApplicationController
  def index
    @budget = Budget.where(:user_id => 1)
  end
end
