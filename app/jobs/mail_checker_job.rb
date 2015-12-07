class MailCheckerJob < ActiveJob::Base
  queue_as :default
  RUN_EVERY = 24.hour
  
  def perform(*args)
    # Do something later
    @gmail = Gmail.connect("pengonow", ENV["MAIL_SECRET"])
    puts @gmail
    
    self.class.set(wait: RUN_EVERY).perform_later
  end
end
