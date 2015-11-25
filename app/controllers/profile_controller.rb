class ProfileController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:save]
  
  def index
    
  end
  def account
  end
  def save    
    document = params[:data_value]
    
    noDoc = Nokogiri::HTML(document)
    
    search = noDoc.xpath("//tr")
    payment = search[6].text.to_s.split("비고")[1].to_s
    nPayment = payment.split("\\r\\n\\r\\n").drop(1)
    nPayment.each do |p|
      budget = Budget.new
      if p.split("\\r\\n")[2].to_s != ""
        # 0 시간 1 계좌 2 타입 3 금액(comma) 4 잔액(comma) 5 사용처
        
        budget.trans_date = p.split("\\r\\n")[0].to_s
        budget.account = p.split("\\r\\n")[1].to_s
        
        if p.split("\\r\\n")[2].to_s == "지급"
          budget.type = "출금"
        else
          budget.type = p.split("\\r\\n")[2].to_s
        end
        
        budget.amount = p.split("\\r\\n")[3].to_s.gsub(",","").to_i
        budget.balance = p.split("\\r\\n")[4].to_s.gsub(",","").to_i
        budget.store = p.split("\\r\\n")[5].to_s
        budget.user_id = 1
            
        budget.save
      end
    end
        
    render :text => search.to_s
  end
end
