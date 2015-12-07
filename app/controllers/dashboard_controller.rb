class DashboardController < ApplicationController
  def index
    @budget = Budget.where(:user_id => 1)
    @gmail = Gmail.connect("pengonow", ENV["MAIL_SECRET"])
  end
end
