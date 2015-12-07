class DashboardController < ApplicationController
  def index
    @budget = Budget.where(:user_id => 1)
    
    MailCheckerJob.perform_later 1
    
    # For production -
    #MailCheckerJob.set(wait: 1.week).perform_later 1
  end
end
