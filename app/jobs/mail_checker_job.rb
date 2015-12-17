class MailCheckerJob < ActiveJob::Base
  queue_as :default
  RUN_EVERY = 1.second
  
  def perform(*args)
    gmail = Gmail.connect(ENV["MAIL_ACCOUNT_NAME"], ENV["MAIL_SECRET"])
    mail = gmail.inbox.emails(:from => ENV["MAIL_SENDER"])
    
    budget = Budget.recents.where(:user_id => 1, :trans_type=> "출금").group("strftime('%Y-%m-%d',trans_date)").sum(:trans_amount)
    dailyCSV = ""
    
    budget.to_a.each do |b|
      dailyCSV += b[0] + " "
    end
    
    dateCollection = []
    
    Migrate.select(:trans_date).each_with_index do |m,i|
      if m.trans_date != nil
        dateCollection[i] = m.trans_date.strftime("%Y-%m-%d")
      end
    end
    
    mail.each do |m|
      visible = m.parts[1].decoded
      f = File.new(DateTime.now.strftime("%Y%m%d").to_s, "w")
      f.write(visible)
      
      date = m.date.to_date.strftime("%Y").to_s + "-"  + m.date.to_date.strftime("%m").to_s + "-" + (m.date.to_date.strftime("%d").to_i - 1).to_s.rjust(2, '0')
      if dateCollection.include? date
      else
        mi = Migrate.new
        mi.bank = "Shinhan"
        mi.receipt = f
        mi.user_id = 1
        mi.trans_date = date.to_date
        
        mi.save
      end
    end
    
    # For recurring :
    #self.class.set(wait: RUN_EVERY).perform_later
  end
end
