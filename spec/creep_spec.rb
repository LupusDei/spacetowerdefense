require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "creep/creep"

describe Creep::Creep1 do
  
  it "should initialize with a level" do
    creep = Creep::Creep1.new(1)
    creep.level.should == 1
  end    
  
  it "should have a specific health and kill value for each level" do
    creep1 = Creep::Creep1.new(1)
    creep1_2 = Creep::Creep1.new(2)
    creep1_3 = Creep::Creep1.new(3)
    creep1.health.should == 10
    creep1_2.health.should >= 20
    creep1_3.health.should >= 30
    creep1.kill_val.should == 1
    creep1_2.kill_val.should >= 2
    creep1_3.kill_val.should >= 3
  end
  
  it "should start near 5,0" do
    creep1 = Creep::Creep1.new(1)
    creep1.should do |x|
      x <= 20
      x >= 0
    end
    creep1.should do |y|
      y  <= 10
      y >= 0
    end
  end
  
  it "should know when it escaped" do
    creep = Creep::Creep1.new(1)
    creep.x = 498
    creep.y = 498
    creep.escaped?.should == true
  end

  it "should have the right image file" do
    Creep::Creep1.new(1).image_file.should == "images/Creep/creep1.png"
  end
  
  it "should be able to take damage" do
    creep1 = Creep::Creep1.new(1)
    health = creep1.health
    creep1.take_damage(2)
    creep1.health.should == (health - 2)
  end
      
  it "should be alive until it has no life" do
    creep1 = Creep::Creep1.new(1)
    creep = Creep::Creep1.new(1)
    live_creep = Creep::Creep1.new(1)
    creep1.alive?.should == true
    creep.alive?.should == true
    live_creep.alive?.should == true
    
    creep1.take_damage(creep1.health)
    creep.take_damage(creep.health + 2)
    live_creep.take_damage(live_creep.health - 1)
    creep1.alive?.should == false
    creep.alive?.should == false
    live_creep.alive?.should == true
  end
  
  it "should initialize the correct prop" do
    prop = mock("prop")
    style = mock("prop")
    prop.stub!(:style).and_return(style)
    creeply = Creep::Creep1.new(1)
    style.should_receive(:background_image=).with(creeply.image_file)
    style.should_receive(:x=) do |x|
      x.to_i.should <= 20
      x.to_i.should >= 0
    end
    style.should_receive(:y=) do |y|
      y.to_i.should <= 0
      y.to_i.should >= -10
    end
    
    creeply.set_prop(prop)
    creeply.prop.should == prop
  end
  
  before do
    
    @prop = mock("prop")
    @style = mock("prop")
    @prop.stub!(:style).and_return(@style)
    @style.stub!(:x=)
    @style.stub!(:y=)
    @style.stub!(:background_image=)
    @creeply = Creep::Creep1.new(1)
    @creeply.x = 5
    @creeply.y = 0
  end
  
  it "should move based off its move speed" do
    
    move_speed = @creeply.move_speed
    @creeply.down
    @creeply.x.should == 5
    @creeply.y.should == 0 + move_speed
    @creeply.up
    @creeply.x.should == 5
    @creeply.y.should == 0
    @creeply.right
    @creeply.x.should == 5 + move_speed
    @creeply.y.should == 0
    @creeply.left
    @creeply.x.should == 5
    @creeply.y.should == 0
  end
  
  it "should move the prop when it moves" do
    @creeply.set_prop(@prop)
    move_speed = @creeply.move_speed
    
    @style.should_receive(:x=).with("#{5 + move_speed}")
    @creeply.right
    @style.should_receive(:y=).with("#{move_speed}")
    @creeply.down
    @creeply.set_prop(@prop)
  end
  
  it "should splat for a period of time when it dies" do
    creep = Creep::Creep1.new(1)
    creep.take_damage(10)
    creep.image_file.should == "images/Creep/splat.png"
    creep.removable?.should == false
    sleep (0.6)
    creep.removable?.should == true
  end
  
  it "should recall its last vector" do
    creep = Creep::Creep1.new(1)
    creep.x = 10
    creep.y = 10
    creep.move_towards(20,20,Time.now)
    vector = Math.sqrt(2)/2
    x_vec, y_vec = creep.last_vector
    x_vec -= vector
    y_vec -= vector
    x_vec.should < 0.001
    x_vec.should > -0.001
    y_vec.should < 0.001
    y_vec.should > -0.001
  end
  
  it "can't move outside the screen except for the start (ymin =-20) x:(0-20) when y<0" do
    creep = Creep::Creep1.new(1)
    creep.x = 15
    creep.y = -15
    creep.move_speed = 3
    creep.right.should == true
    creep.right.should == false
    creep.x.should == 15 + creep.move_speed
    creep.up.should == true
    creep.up.should == false
    creep.y.should == -15 - creep.move_speed
    creep.x = 5
    creep.y = 499
    creep.down.should == false
    creep.y.should == 499
    creep.x = 495
    creep.y = 40
    creep.right.should == false
    creep.x.should == 495
    creep.x = 0
    creep.left.should == false
    creep.x.should == 0
    creep.x = 40
    creep.y = 0
    creep.up.should == false
    creep.y.should == 0
  end
  
  it "should be able to be stunned" do
    creep = Creep::Creep1.new(1)
    creep.move_speed.should > 0
    creep.stun
    creep.move_speed.should == 0
    creep.removable?.should == false
  end
  
  it "should be able to be slowed" do
  
    creep = Creep::Creep1.new(1)
    creep.move_speed = 4
    creep.slow
    creep.move_speed.should == 2
    
  end
      
  it "should move in the direction of the given coordinates" do
    creep = Creep::Creep1.new(1)
    creep.set_center(10,10)
    creep.move_speed = 3
    creep.move_towards(20,20, Time.now)
    x,y = creep.get_center
    x.should == 12
    y.should == 12
  end
  
  it "should only move if it is time to move" do
    creep = Creep::Creep1.new(1)
    creep.set_center(10,10)
    creep.move_speed = 3
    creep.move_towards(20,20, Time.now)
    creep.is_time_to_move?(Time.now).should == false
    sleep(Creep::MOVE_SLEEP_TIME + 0.001)
    creep.is_time_to_move?(Time.now).should == true
  end
  it "should move a distance based off time" do
    creep = Creep::Creep1.new(1)
    creep.set_center(10,10)
    creep.move_speed = 3
    creep.move_towards(20,20, Time.now)
    x,y = creep.get_center
    x.should == 12
    creep.move_towards(20,20, Time.now)
    x,y = creep.get_center
    x.should == 12
    sleep(Creep::MOVE_SLEEP_TIME + 0.001)
    dist = creep.move_distance(Time.now) - Creep::MOVE_SLEEP_TIME * 10 * creep.move_speed
    (-0.1..0.1).should === dist
    creep.move_towards(20,20, Time.now)
    x,y = creep.get_center
    x.should >= 14
    
  end
  
  it "should be able to tell where its center is" do
    creep = Creep::Creep1.new(1)
    creep.x = 10
    creep.y = 10
    x,y = creep.get_center
    x.should == creep.x + CREEP_RADIUS
    y.should == creep.y + CREEP_RADIUS
  end
  
  it  "should be able to set its x and y based off coordinates for its center" do
    creep = Creep::Creep1.new(1)
    creep.set_center(18,18)
    creep.x.should == 18 - CREEP_RADIUS
    creep.y.should == 18 - CREEP_RADIUS
  end
    
    
end