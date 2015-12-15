class DashboardController < ApplicationController
  PROCESS = true
  
  def index
    @budget = Budget.where(:user_id => 1)
    
    if PROCESS
      MailCheckerJob.perform_later 1
    end
    
    # For production -
    # MailCheckerJob.set(wait: 24.hour).perform_later 1
  end
end