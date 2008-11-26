require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "money/money"

describe Money do
  
  it "should initialize with a given amount in the bank" do
    money = Money.new(100)
    money.bank.should == 100
  end
  
  it "can check if you have enough money to buy things" do
    money = Money.new(100)
    money.can_buy?(10).should == true
    money.can_buy?(1000).should == false
  end
  
  it "will subtract the purchase cost from the bank" do
    money = Money.new(20)
    money.buy(10)
    money.bank.should == 10
  end
  
  it "should not allow the buying of things without enough money" do
    money = Money.new(29)
    tower_cost = 10
    money.buy(tower_cost).should == true
    money.buy(20).should == false
    money.bank.should == 19
  end
  
  it "can collect interest" do
    money = Money.new(100)
    money.collect_interest
    money.bank.should == 112
  end
  
end
    