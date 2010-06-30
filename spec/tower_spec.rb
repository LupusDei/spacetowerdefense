require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "tower/tower"

describe Tower::GammaTower do
  
  it "should initialize with an x,y, and level" do
    tower = Tower::GammaTower.new(40,40,1)
    tower.x.should == 40
    tower.y.should == 40
    tower.level.should == 1
  end
  
  it "should have a specific damage, range, and attack speed for each level" do
    tower = Tower::GammaTower.new(40,40,1)
    tower.damage.should >= 4
    tower.range.should >= 3
    tower.attack_speed.should >= 1
    tower = Tower::GammaTower.new(40,40,2)
    tower.damage.should >= 4
    tower.range.should >= 3
    tower.attack_speed.should >= 1
    tower = Tower::GammaTower.new(40,40,3)
    tower.damage.should >= 4
    tower.range.should >= 3
  end
  
  it "should have a buy value" do
    tower = Tower::GammaTower.new(40,40,1)
    tower.class.cost[tower.level].should == 10
  end
  
  it "should only build on multiples of 20" do
    tower = Tower::GammaTower.new(20,40,1)
    tower2 = Tower::GammaTower.new(57,89,1)
    tower.placed?.should == true
    tower2.placed?.should == false
  end

  it "should have the correct image" do
    tower = Tower::GammaTower.new(20,40,1)
    tower.image_file.should == "images/towers/GammaTower.png"
  end
  
  it "should initialize a prop" do
    tower = Tower::GammaTower.new(20,40,1)
    prop = mock("prop")
    style = mock("style")
    prop.stub!(:style).and_return(style)
    style.should_receive(:background_image=).with(tower.image_file)
    style.should_receive(:x=).with(tower.x.to_s)
    style.should_receive(:y=).with(tower.y.to_s)
    tower.set_prop(prop)
    tower.prop.should == prop
  end
  
  it "should be able to shoot a creep" do
    tower = Tower::GammaTower.new(20,40,1)
    creep = mock("creep")
    health = 10
    x = 10
    y = 10
    creep.stub!(:x).and_return(x)
    creep.stub!(:y).and_return(y)
    creep.stub!(:alive?).and_return(true)
    tower.can_shoot?(creep).should == true
  end
  
  it "should only be able to shoot creep within range" do
    tower = Tower::GammaTower.new(20,40,1)
    creep = mock("creep")
    creep2= mock("creep")
    x = [15,180]
    y = [15,180]
    health = [10,10]
    creep.stub!(:x).and_return(x[0])
    creep.stub!(:y).and_return(y[0])
    creep.stub!(:alive?).and_return(true)
    creep2.stub!(:alive?).and_return(true)    
    creep2.stub!(:x).and_return(x[1])
    creep2.stub!(:y).and_return(y[1])
    tower.can_shoot?(creep).should == true
    tower.can_shoot?(creep2).should == false
  end
  
  it "should only shoot living creep" do
    tower = Tower::GammaTower.new(20,40,1)
    creep = mock("creep")
    x = 15
    y = 15
    health = 10
    creep.stub!(:x).and_return(x)
    creep.stub!(:y).and_return(y)
    creep.stub!(:alive?).and_return(true)
    tower.can_shoot?(creep).should == true
    tower.can_shoot?(creep).should == true
    creep.stub!(:alive?).and_return(false)
    tower.can_shoot?(creep).should == false
  end
  
  it "should only be able to shoot every cooldown" do
    tower = Tower::GammaTower.new(20,40,1)
    creep = Creep::Creep1.new(1)
    tower.is_time_to_shoot?(4).should == true
    tower.fire_projectile(creep, 4)
    tower.is_time_to_shoot?(4).should == false
  end
  
  it "should be able to acquire a target" do
    tower = Tower::GammaTower.new(40,40,1)
    creep = Creep::Creep1.new(1)
    creep.x = 20
    creep.y = 20
    tower.can_shoot?(creep).should == true
    tower.target.should == creep
  end
  
  it "should have a splash damage range/area" do
    tower = Tower::GammaTower.new(40,40,1)
    tower.class.splash_range[1].should >=4
    tower.class.splash_damage[1].should >= 3
  end
  
  before do
    @creep = Creep::Creep1.new(1)
    @creep.x = 20
    @creep.y = 20
    @creep2 = Creep::Creep1.new(1)
    @creep2.x = 25
    @creep2.y = 20
    @creep3 = Creep::Creep1.new(1)
    @creep3.x = 20
    @creep3.y = 25
    @close_creep = [@creep2, @creep3]
  end
  
  it "should get a list of close creep for splash damage" do
    tower = Tower::GammaTower.new(40,40,1)
    projectile = tower.fire_projectile(@creep,Time.now, @close_creep)
    projectile.close_creep.include?(@creep2).should == true
  end
  
  it "should have a splash damage" do
    tower = Tower::GammaTower.new(40,40,1)
    tower.can_shoot?(@creep).should == true
    projectile = tower.fire_projectile(@creep, Time.now,@close_creep)
    health = @creep.health
    2.times {|i| projectile.direct_projectile(i)}
    projectile.hit_creep?.should == true
    @creep.health.should == health - tower.damage
    @creep2.health.should == health - tower.class.splash_damage[1]
    @creep3.health.should == health - tower.class.splash_damage[1]
  end

  it "should be able to be told to sleep" do
    random_clock = 2
    tower = Tower::GammaTower.new(40,40,1)
    tower.is_time_to_shoot?(random_clock).should == true
    tower.sleep_for(3)
    tower.is_time_to_shoot?(random_clock).should == false
    random_clock = 3
    tower.is_time_to_shoot?(random_clock).should == false
    random_clock = 6
    tower.is_time_to_shoot?(random_clock).should == true
  end

end

describe Tower::KineticTower do
  
  it "should rotate its image to point at the creep" do
    tower = Tower::KineticTower.new(40,40,1)
    creep = Creep::Creep1.new(1)
    creep.health = 50
    creep.x = 20
    creep.y = 15
    random_time = 3
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/kineticTower/KineticTower120.png"
    creep.x = 80
    creep.y = 40
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/kineticTower/KineticTower0.png"
    creep.x = 20
    creep.y = 35
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/kineticTower/KineticTower150.png"
    creep.x = 20
    creep.y = 90
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/kineticTower/KineticTower240.png"
    creep.x = 80
    creep.y = 90
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/kineticTower/KineticTower300.png"
  end
end

describe Tower::HotNeedleOfInquiry do
  
  it "should rotate its image to point at the creep" do
    tower = Tower::HotNeedleOfInquiry.new(40,40,1)
    creep = Creep::Creep1.new(2)
    creep.x = 20
    creep.y = 15
    random_time = 3
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry130.png"
    creep.x = 80
    creep.y = 40
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry30.png"
    creep.x = 20
    creep.y = 35
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry150.png"
    creep.x = 20
    creep.y = 90
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry230.png"
    creep.x = 80
    creep.y = 90
    tower.fire_projectile(creep, random_time)
    tower.image_file.should == "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry310.png"
  end
end

describe Tower::GravityTower do
  
  it "should have the correct image file" do
    tower = Tower::GravityTower.new(40,40,1)
    tower.image_file.should == "images/towers/GravityTower/GravityTower.png"
  end
  
  it "should have an attack range of 1" do
    tower = Tower::GravityTower.new(40,40,1)
    tower.range.should == 1.5
  end
  
  it "should switch coronas that it increases in transparency back and forth with each attack" do
    tower = Tower::GravityTower.new(40,40,1)
    creep = Creep::Creep1.new(2)
    creep.x = 20
    creep.y = 40
    random_time = 3
    corona = tower.fire_projectile(creep, random_time)
    corona.image_file.should == "images/projectiles/CoronaInner.png"
    corona2 = tower.fire_projectile(creep, random_time)
    corona2.image_file.should == "images/projectiles/CoronaOuter.png"
  end
  
  it "should only attack creep within a small range around it" do
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
     tower.in_range?(creep2).should == true
     random_time = 3
     corona = tower.fire_projectile(creep, random_time,close_creep)
     creep.health.should == health - tower.damage
     creep2.health.should == health - tower.damage
     creep1.health.should == health - tower.damage
   end
  
  it "should have a chance to stun the creep" do
    tower = Tower::GravityTower.new(40,40,1)
    tower.class.chance_to_stun[1].should > 5
  end
  
end

describe Tower::ImprobabilityTower do
  
  it "should have the correct image" do
    tower = Tower::ImprobabilityTower.new(40,40,1)
    tower.image_file.should == "images/towers/ImprobabilityTower.png"
  end
  
  it "should be able to attack a creep anywhere and do a random damage in range of level" do
    tower = Tower::ImprobabilityTower.new(400,400,1)
    creep = Creep::Creep1.new(1)
    tower.class.rand_num = mock("RandomNumberGenerator")
    tower.class.rand_num.stub!(:get).and_return(3)
    random_time = 3
    random = tower.fire_projectile(creep, random_time)
    creep.health.should == 7
  end
  
end

describe Tower::TimeWrappingTower do
  
  it "should have the correct image" do
    tower = Tower::TimeWrappingTower.new(40,40,1)
    tower.image_file.should == "images/towers/TimeWrappingTower.png"
  end
  
end

describe Tower::DimensionalPhaseTower do
  
  before do
    @tower = Tower::DimensionalPhaseTower.new(40,40,1)
    @creep = Creep::Creep1.new(1)
  end
  
  it "should have the correct image" do
    @tower.image_file.should ==  "images/towers/DimensionalPhaseTower.png"
  end
  
  it "should have a limited range" do
    @creep.set_center(20,20)
    @tower.in_range?(@creep).should == true
    @creep.set_center(250,250)
    @tower.in_range?(@creep).should == false
    @creep.set_center(100,60)
    @tower.in_range?(@creep).should == true
  end
  
  it "should generate PhasePulses" do
    @creep.set_center(20,20)
    random_time = 3
    pusle = @tower.fire_projectile(@creep, random_time)
    pusle.class.name.should == "Projectile::PhasePulse"
  end
  
end
