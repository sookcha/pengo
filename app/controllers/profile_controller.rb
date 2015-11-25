class ProfileController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:save]
  
  def index
  end
  
  def update
    
  end
  
  def save
    document = params[:data_value]
    
    noDoc = Nokogiri::HTML(document)
    
    search = noDoc.xpath("//tr")
    searchDate = noDoc.xpath("//strong")
    
    date = searchDate.text.to_s
        
    payment = search[6].text.to_s.split("비고")[1].to_s
    nPayment = payment.split("\\r\\n\\r\\n").drop(1)
        
    nPayment.each do |p|
      budget = Budget.new
      if p.split("\\r\\n")[2].to_s != ""
        # 0 시간 1 계좌 2 타입 3 금액(comma) 4 잔액(comma) 5 사용처
        budget.trans_date = date + "T" + p.split("\\r\\n")[0].to_s        
        budget.trans_account = p.split("\\r\\n")[1].to_s
        
        if p.split("\\r\\n")[2].to_s == "지급"
          budget.trans_type = "출금"
        else
          budget.trans_type = p.split("\\r\\n")[2].to_s
        end
        
        budget.trans_amount = p.split("\\r\\n")[3].to_s.gsub(",","").to_i
        budget.trans_balance = p.split("\\r\\n")[4].to_s.gsub(",","").to_i
        budget.trans_store = p.split("\\r\\n")[5].to_s
        budget.user_id = 1
            
        budget.save
      end
    end
    
    render :text => "Done"
    redirect_to "/dashboard"
  end
  def data
    @budget = Budget.where(:user_id => 1)
    respond_to do |format|
      format.csv {
        render :csv => @budget, :only => [:trans_store,:trans_amount]
      }
    end
  end
end
