class ProfileController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:save]
  
  def index
    @budget = Budget.where(:user_id => 1)
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
    budget = Budget.recents.where(:user_id => 1)
    
    totalPay = 0
    
    mart = 0
    food = 0
    internetServices = 0
    transport = 0
    
    budget.each do |b|
      totalPay += b.trans_amount
      if b.trans_type == "출금"
        if b.trans_store.include? "마트" or b.trans_store.include? "GS" or b.trans_store.include? "CU" or b.trans_store.include? "세븐일레븐"
          mart += b.trans_amount
      
        elsif b.trans_store.include? "파리바게뜨" or b.trans_store.include? "푸드"
          food += b.trans_amount
        
        elsif b.trans_store.include? "ITUNES.CO" or b.trans_store.include? "PG" or b.trans_store.include? "세븐일레븐"
          internetServices += b.trans_amount
        
        elsif b.trans_store.include? "승차권"
          transport += b.trans_amount
          
        end
      end
    end
    
    martPercentage = (mart.fdiv(totalPay).round(2)*100).to_i
    foodPercentage = (food.fdiv(totalPay).round(2)*100).to_i
    internetServicesPercentage = (internetServices.fdiv(totalPay).round(2)*100).to_i
    transportPercentage = (transport.fdiv(totalPay).round(2)*100).to_i
    
    etcPercentage = 100 - (martPercentage + internetServicesPercentage + foodPercentage)
    
    respond_to do |format|
      format.csv {
        render :text => "type,percentage\r\n편의점+마트," + martPercentage.to_s + "\r\n음식," + foodPercentage.to_s  + "\r\n인터넷서비스," + internetServicesPercentage.to_s + "\r\n교통," + transportPercentage.to_s + "\r\n기타," + etcPercentage.to_s}
      
    end
  end
    
  def dailydata
    budget = Budget.recents.where(:user_id => 1, :trans_type=> "출금").group("strftime('%Y-%m-%d',trans_date)").sum(:trans_amount)
    dailyCSV = "date\tamount\r\n"
    
    budget.to_a.each do |b|
      dailyCSV += b[0] + "\t" + b[1].to_s + "\r\n"
    end
    
    render :text => dailyCSV
  end
end