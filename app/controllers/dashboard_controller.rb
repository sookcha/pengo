class DashboardController < ApplicationController
  def index
    @budget = Budget.where(:user_id => 1)
    
    MailCheckerJob.perform_later 1
    # For production -
    #MailCheckerJob.set(wait: 24.hour).perform_later 1
  end
end
