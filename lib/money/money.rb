class Money
  
  attr_accessor :bank
  
  def initialize(start_money)
    @bank = start_money
  end
  
  def can_buy?(cost)
    return true if @bank >= cost
    return false
  end
  
  def buy(cost)
    if can_buy?(cost)
      @bank -= cost
      return true
    end
    return false
  end
  
  def sell(cost)
    @bank += cost / 1.5
  end
  
  def collect_interest
    @bank += @bank * 0.12
  end 
end