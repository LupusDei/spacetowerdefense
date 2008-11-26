require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "creep/creep_navigation"

describe CreepNavigation do
  
  before do
    @navigator = CreepNavigation.new
    @towers = []
    @towers << Tower::GammaTower.new(40,40,1)
    @towers << Tower::GammaTower.new(0,0,1)
  end
  
  it "should know about the towers it must navigate around" do
    @navigator.update_towers(@towers)
    @navigator.towers.should == @towers
  end
  
  it "should know if it is about to lead a creep into a tower" do
    creep = Creep::Creep1.new(1)
    creep.x = 43
    creep.y = 38
    creep.move_speed.should == 5
    @navigator.update_towers(@towers)
    @navigator.hit_tower_if_go?(creep,'down').should == true
    @navigator.hit_tower_if_go?(creep,'left').should == true
    @navigator.hit_tower_if_go?(creep,'right').should == false    
    @navigator.hit_tower_if_go?(creep,'up').should == false
  end
  
  it "should have a correct path array" do
    @navigator.correct_path.should == nil
    @navigator.correct_path = CreepNavigation::CorrectPath.new(80,80)
    @navigator.correct_path.x.last.should == 80
    @navigator.correct_path.y.last.should == 80
  end
  
  it "should be able to find which directions are open" do
    creep = Creep::Creep1.new(1)
    creep.x = 43
    creep.y = 38
    @navigator.update_towers(@towers)
    directions = @navigator.open_directions(creep)
    directions['down'].should == false
    directions['left'].should == false
    directions['up'].should == true
    directions['right'].should == true
  end
  
  it "should be able to see all open directions" do
    creep = Creep::Creep1.new(1)
    creep.x = 85
    creep.y = 89
    towers = []
    towers << Tower::GammaTower.new(0,40,1)
    towers << Tower::GammaTower.new(40,40,1)
    towers << Tower::GammaTower.new(100,0,1)
    towers << Tower::GammaTower.new(100,40,1)
    towers << Tower::GammaTower.new(100,80,1)
    towers << Tower::GammaTower.new(60,100,1)
    @navigator.update_towers(towers)
    directions = @navigator.open_directions(creep)
    directions['left'].should == true
  end
  
  it "should calculate the distance to the end" do
    creep = Creep::Creep1.new(1)
    creep.x = 0
    creep.y = 0
    distance = 707.1067811865476
    @navigator.distance_to_end(creep.x,creep.y).should == distance
  end
  
  it "should find the best direction" do
    creep = Creep::Creep1.new(1)
    creep.x = 43
    creep.y = 38
    @navigator.update_towers(@towers)
    best = @navigator.best_direction(creep)
    best.first.should == 'right'  
  end
  
  it "should return true if the best move was the creeps last move" do
    creep = Creep::Creep1.new(1)
    creep.x = 43
    creep.y = 38
    @navigator.update_towers(@towers) 
    creep.last_move = 'left'
    @navigator.best_direction(creep).should == true
  end
      it "should check for blocking" do
    @towers = []
    @towers << Tower::GammaTower.new(0,40,1)
    @towers << Tower::GammaTower.new(@towers.last.x + 40,40,1) until (@towers.last.x + 40) == 480
    @navigator.is_there_blocking?(@towers).should == false
    @towers << Tower::GammaTower.new(460,0,1)
    @navigator.is_there_blocking?(@towers).should == true
  end
  
  it "should only say blocking if there is really a block" do
    @towers = []
    @towers << Tower::GammaTower.new(0,40,1)
    @towers << Tower::GammaTower.new(40,40,1)
    @towers << Tower::GammaTower.new(100,0,1)
    @towers << Tower::GammaTower.new(100,40,1)
    @towers << Tower::GammaTower.new(100,80,1)
    @towers << Tower::GammaTower.new(60,100,1)
    @navigator.is_there_blocking?(@towers).should == false
  end
  
end