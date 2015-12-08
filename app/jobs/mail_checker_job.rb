class MailCheckerJob < ActiveJob::Base
  queue_as :default
  RUN_EVERY = 1.second
  
  def perform(*args)
    gmail = Gmail.connect(ENV["MAIL_ACCOUNT_NAME"], ENV["MAIL_SECRET"])
    @mail = gmail.inbox.emails(:from => ENV["MAIL_SENDER"]).first
    
    @visible = @mail.attachments[0].body.decoded
    f = File.new(DateTime.now.strftime("%Y%m%d").to_s, "w")
    f.write(@visible)
    
    m = Migrate.new
    m.bank = "Shinhan"
    m.receipt = f
    m.save
                
    # For recurring :
    #self.class.set(wait: RUN_EVERY).perform_later
  end
end
