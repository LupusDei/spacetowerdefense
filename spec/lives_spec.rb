require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "lives/lives"

describe Lives do
  
  it "should initialize with a certain number of lives" do
    these_lives = Lives.new(20)
    these_lives.lives.should == 20
  end
  
  it "should be able to subtract lives when told" do
    these_lives = Lives.new(20)
    these_lives.lost_life
    these_lives.lives.should == 19
  end
  
  it "should know when there are no lives left" do
    these_lives = Lives.new(1)
    these_lives.lives_left?.should == true
    these_lives.lost_life
    these_lives.lives_left?.should == false
  end
  
end
