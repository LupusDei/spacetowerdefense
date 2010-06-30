require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require 'projectile/projectile.rb'

describe Projectile::GammaProjectile do
  
  it "should initialize correctly" do
    tower = Tower::GammaTower.new(20,20,1)
    creep = Creep::Creep1.new(1)
    projectile = Projectile::GammaProjectile.new(tower, creep)
    projectile.x.should == tower.x
    projectile.y.should == tower.y
    projectile.tower.should == tower
    projectile.creep.should == creep
  end
  
  it "should have a move speed" do
    tower = Tower::GammaTower.new(20,20,1)
    creep = Creep::Creep1.new(1)
    projectile = tower.fire_projectile(creep)
    projectile.move_speed.should_not == nil
  end
  
  it "should get the right vectors" do
    tower = Tower::GammaTower.new(240,240,1)
    creep = Creep::Creep1.new(1)
    creep.x = 5
    creep.y = 0
    projectile = Projectile::GammaProjectile.new(tower, creep)
    x,y = projectile.get_unit_vector(creep)
    x.should == 0.699624792608213
    y.should == 0.714510426493494
  end
  
  it "should have predictive targeting" do
     tower = Tower::GammaTower.new(100,100,1)
     creep = Creep::Creep1.new(1)
     creep.x = 90
     creep.y = 150
     creep.move_speed = 3
     creep.right
     creep.right
     projectile = tower.fire_projectile(creep)
     vectors = 0, -1
     projectile.predictive_shot.should == vectors
     projectile.x_vector.should == 0 
     projectile.y_vector.should == -1
   end
   
   it "should only move if it is time to move" do
     tower = Tower::GammaTower.new(40,40,1)
     creep = Creep::Creep1.new(1)
     projectile = tower.fire_projectile(creep)
     projectile.direct_projectile
     projectile.is_time_to_move?.should == false
     sleep(Projectile::MOVE_SLEEP_TIME + 0.001)
     projectile.is_time_to_move?.should == true
   end
   it "should move a distance based off time" do
     tower = Tower::GammaTower.new(40,40,1)
     creep = Creep::Creep1.new(1)
     projectile = tower.fire_projectile(creep)
     projectile.direct_projectile
     new_x = projectile.x
     new_x.should < 40
     projectile.direct_projectile
     projectile.x.should == new_x
     sleep(Projectile::MOVE_SLEEP_TIME + 0.001)
     projectile.how_many_times_it_should_move(Time.now).should == (Projectile::MOVE_SLEEP_TIME * 10 * projectile.move_speed + 0.5).to_i
     projectile.direct_projectile
     projectile.x.should < new_x
   end
   
  it "should move towards its target" do
      tower = Tower::GammaTower.new(40,40,1)
      creep = Creep::Creep1.new(1)
      creep.x = 5
      creep.y = 5
      creep2 = Creep::Creep1.new(1)
      creep2.x = 50
      creep2.y = 50
      projectile = Projectile::GammaProjectile.new(tower,creep)
      projectile2 = Projectile::GammaProjectile.new(tower,creep2)
      projectile.direct_projectile()
      projectile2.direct_projectile()
      sleep(0.1)
      projectile.x.should < 40
      projectile.y.should < 40
      projectile2.x.should > 40
      projectile2.y.should > 40   
    end
    
  it "should know when it hits its target" do
    tower = Tower::GammaTower.new(40,40,1)
    creep = Creep::Creep1.new(1)
    creep.x = 36
    creep.y = 36
    projectile = Projectile::GammaProjectile.new(tower,creep)
    projectile.hit_creep?.should == true
  end
  
  it "should deal damage to the creep when it hits it" do
    tower = Tower::GammaTower.new(40,40,1)
    creep = Creep::Creep1.new(1)
    health = creep.health
    projectile = Projectile::GammaProjectile.new(tower,creep)
    2.times {|i| projectile.direct_projectile(i)}
    creep.health.should == (health - tower.damage)
  end
  
  it "should know when it is done" do
    tower = Tower::GammaTower.new(40,40,1)
    creep = Creep::Creep1.new(1)
    creep.x = 35
    creep.y = 35
    projectile = tower.fire_projectile(creep)
    projectile.hit_creep?.should == true
    projectile.is_done?.should == true
    creep.x = 300
    creep.y = 300
    projectile = tower.fire_projectile(creep)
    6.times {|i| projectile.direct_projectile(i)}
    projectile.is_done?.should == true
    projectile = tower.fire_projectile(creep)
    creep.take_damage(10)
    creep.alive?.should == false
    projectile.is_done?.should == true
  end
  
  it "should have a timed life" do
    tower = Tower::GammaTower.new(200,200,1)
    creep = Creep::Creep1.new(1)
    creep.x = 50
    creep.y = 50
    projectile = tower.fire_projectile(creep)
    projectile.timed_out?.should == false
    5.times {|i| projectile.direct_projectile(i)}
    projectile.timed_out?.should == true
  end
  
  before do
    @space = mock("space")
    @creep1 = Creep::Creep1.new(1)
    @creep1.x = 25
    @creep1.y = 20
    @creep2 = Creep::Creep1.new(1)
    @creep2.x = 20
    @creep2.y = 25
    @close_creep = [@creep1,@creep2]
  end
  
  it "should have a splash damage affect" do 
    tower = Tower::GammaTower.new(40,40,1)
    creep = Creep::Creep1.new(1)
    creep.x = 20
    creep.y = 20
    health = creep.health
    projectile = tower.fire_projectile(creep,1, @close_creep)
    projectile.close_creep.length.should == 2
    
    2.times {|i| projectile.direct_projectile(i)}
    creep.health.should == health - tower.damage
    projectile.close_creep.length.should == 2
    projectile.close_creep[0].health.should == health - tower.class.splash_damage[1]
  end
  
  it "should initialize its prop correctly" do
    prop = mock("prop")
    style = mock("style")
    prop.stub!(:style).and_return(style)
    tower = Tower::GammaTower.new(40,40,1)
    creep = Creep::Creep1.new(1)
    projectile = Projectile::GammaProjectile.new(tower,creep)
    style.should_receive(:x=).with(tower.x.to_s)
    style.should_receive(:y=).with(tower.y.to_s)
    style.should_receive(:width=)
    style.should_receive(:height=)
    style.should_receive(:background_image=).with("images/projectiles/photon_burst.png")
    projectile.set_prop(prop)
    projectile.prop.should == prop
  end
end

describe Projectile::InquiryFusion do
  
  it "should follow the angle of the tower" do
    tower = Tower::HotNeedleOfInquiry.new(40,40,1)
    creep = Creep::Creep1.new(2)
    creep.x = 53
    creep.y = 23
    fusion = tower.fire_projectile(creep)
    fusion.x.should == 50
    fusion.y.should == 22
    creep.x = 20
    creep.y = 20
    fusion = tower.fire_projectile(creep)
    fusion.x.should == 28
    fusion.y.should == 30
  end
  
  
  
end


describe Projectile::GravityCorona do
  
  it "should have an inner and outer image depending on if it is first fired or second" do
    tower = Tower::GravityTower.new(40,40,1)
    creep = Creep::Creep1.new(2)
    corona = tower.fire_projectile(creep)
    corona.image_file.should == "images/projectiles/CoronaInner.png"
    corona2 = tower.fire_projectile(creep)
    corona2.image_file.should == "images/projectiles/CoronaOuter.png"
  end
  
  
  it "should generate the correct prop" do
    tower = Tower::GravityTower.new(40,40,1)
    creep = Creep::Creep1.new(1)
    corona = tower.fire_projectile(creep)
    prop = mock("prop")
    style = mock("style")
    prop.stub!(:style).and_return(style)
    style.should_receive(:x=).with((tower.x - 15).to_s)
    style.should_receive(:y=).with((tower.y - 15).to_s)
    style.should_receive(:width=).with("70")
    style.should_receive(:height=).with("70")
    style.should_receive(:background_image=).with("images/projectiles/CoronaInner.png")
    style.should_receive(:transparency=)
    corona.set_prop(prop)
    corona.prop.should == prop
  end
  
  it "should have a chance to stun the creep it hits" do
    tower = Tower::GravityTower.new(40,40,1)
    creep = Creep::Creep1.new(2)
    creep1 = Creep::Creep1.new(2)
    creep2 = Creep::Creep1.new(2)
    health = creep.health
    close_creep = [creep1,creep2]
    creep.x = 23
    creep.y = 40
    creep1.x = 23
    creep1.y = 37
    creep2.x = 105
    creep2.y = 43
    tower.fire_projectile(creep,close_creep)
    tower.fire_projectile(creep,close_creep)
    tower.fire_projectile(creep,close_creep)
    tower.fire_projectile(creep,close_creep)
    tower.fire_projectile(creep,close_creep)
  end
  
end

describe Projectile::ImprobabilityProjectile do
  
  it "should have a list of random images that it will assign at random at creation" do
    tower = Tower::ImprobabilityTower.new(40,40,1)
    creep = Creep::Creep1.new(2)
    tower.class.rand_num = mock("RandomNumberGenerator")
    tower.class.rand_num.stub!(:get).and_return(0)
    projectile = tower.fire_projectile(creep)
    tower.class.rand_num.stub!(:get).and_return(11)
    projectile1 = tower.fire_projectile(creep)
    tower.class.rand_num.stub!(:get).and_return(22)
    projectile2 = tower.fire_projectile(creep)
    projectile.image_file.should == "images/projectiles/improbability_projectiles/Bone.png"
    projectile1.image_file.should == "images/projectiles/improbability_projectiles/Ginzer.png"
    projectile2.image_file.should == "images/projectiles/improbability_projectiles/LightBulb.png"
    
  end
  
  it "should always hit and be at the creep doing a damage determined by the tower" do
    tower = Tower::ImprobabilityTower.new(40,40,1)
    creep = Creep::Creep1.new(2)
    health = creep.health
    tower.class.rand_num = mock("RandomNumberGenerator")
    tower.class.rand_num.stub!(:get).and_return(5)
    projectile = tower.fire_projectile(creep)
    projectile.x.should == creep.x
    projectile.y.should == creep.y
    creep.health.should == health - 5
  end
  
  it "should initialize its prop right on top of that fat creep" do
    tower = Tower::ImprobabilityTower.new(40,40,1)
    creep = Creep::Creep1.new(2)
    tower.class.rand_num = mock("RandomNumberGenerator")
    tower.class.rand_num.stub!(:get).and_return(0)
    projectile = tower.fire_projectile(creep)
    prop = mock("prop")
    style = mock("style")
    prop.stub!(:style).and_return(style)
    style.should_receive(:x=).with((creep.x).to_s)
    style.should_receive(:y=).with((creep.y).to_s)
    style.should_receive(:width=).with("25")
    style.should_receive(:height=).with("25")
    style.should_receive(:background_image=).with("images/projectiles/improbability_projectiles/Bone.png")
    style.should_receive(:transparency=)
    projectile.set_prop(prop)
    projectile.prop.should == prop
  end
end

describe Projectile::TimeBubble do
  
  it "should always hit its target and be over it" do
    centering_amount = 2
    tower = Tower::TimeWrappingTower.new(40,40,1)
    creep = Creep::Creep1.new(2)
    health = creep.health
    bubble = tower.fire_projectile(creep)
    bubble.x.should == creep.x - centering_amount
    bubble.y.should == creep.y - centering_amount
    creep.health.should == health - tower.damage
  end
  
end

describe Projectile::PhasePulse do
  
  before do
    @tower = Tower::DimensionalPhaseTower.new(40,40,1)
    @creep = Creep::Creep1.new(2)
  end
  
  it "should leave from the center of the tower" do
    pulse = @tower.fire_projectile(@creep)
    pulse.x.should == 60
    pulse.y.should == 60
  end

  it "should have a power from the tower level to dictate the thickness of the pulse" do
    @tower.level = 1
    pulse = @tower.fire_projectile(@creep)
    pulse.strength.should == 1
    @tower.level = 2
    pulse = @tower.fire_projectile(@creep)
    pulse.strength.should == 2
  end
  
  it "should generate a series of points that represent a sine wave" do
    @creep.set_center(100,60)
    @tower.in_range?(@creep).should == true
    pulse = @tower.fire_projectile(@creep)
    pulse.wave_x[0].should == 60
    y = pulse.wave_y[0] - 60
    (-5..5).should === y
    pulse.wave_x[1].should == 62
    y = pulse.wave_y[1] - 61.1079
    (-5..5).should === y
    x = pulse.wave_x.last - 100
    (-5..5).should === x
    y= pulse.wave_y.last - 60
    (-5..5).should === y
  end
  
  it "should generate a decent set of points when the creep is vertical" do
    @creep.set_center(60,30)
    pulse = @tower.fire_projectile(@creep)
    x = pulse.wave_x[0]- 60
    (-5..5).should === x
    y = pulse.wave_y[0] - 60
    (-5..5).should === y
    x = pulse.wave_x.last - 60
    (-2..2).should === x
    y = pulse.wave_y.last - 30
    (-5..5).should === y
    
  end
  
  it "should deal damage right away" do
    @creep.set_center(90,50)
    health = @creep.health
    @tower.fire_projectile(@creep)
    @creep.health.should == health - @tower.damage
    
  end
    
  
  
end
