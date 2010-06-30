require File.expand_path(File.dirname(__FILE__) + "/spec_helper.rb")


describe Space do
  before do
    @space = Space.new
    @space_frame = mock("space_frame")
    @space_frame.stub!(:create_creep)
    @space_frame.stub!(:place_tower)
    @space_frame.stub!(:create_projectile)
    @space_frame.stub!(:remove_projectile)
    @space_frame.stub!(:kill_creep)
    @space_frame.stub!(:game_over)
    @space_frame.stub!(:update_all)
    @space_frame.stub!(:display_next_creep)
    @space_frame.stub!(:play_sound)
    @space_frame.stub!(:sound_option)
    @space.new_game(@space_frame)
  end
  
  it "should make some creep" do
    @space.create_creep(@space.creep_wave)
    @space.creep.should_not == nil
  end
  
  it "should not be able to stack towers" do     
     @space.place_tower("GammaTower", 240, 240, 1).should == true
     @space.place_tower("GammaTower", 240, 240, 1).should == false
     @space.place_tower("GammaTower", 240, 260, 1).should == false
     @space.place_tower("GammaTower", 260, 240, 1).should == false
     @space.place_tower("GammaTower", 260, 260, 1).should == false
     @space.place_tower("GammaTower", 240, 220, 1).should == false
     @space.place_tower("GammaTower", 220, 240, 1).should == false
     @space.place_tower("GammaTower", 220, 220, 1).should == false
     @space.place_tower("GammaTower", 220, 260, 1).should == false
     @space.place_tower("GammaTower", 260, 220, 1).should == false
     @space.towers.length.should == 1
   end
   
     it "should not be able to place towers outside the screen" do
       @space.place_tower("GammaTower", -20, 0, 1).should == false
       @space.place_tower("GammaTower", 0, -20, 1).should == false
       @space.place_tower("GammaTower", 480, 0, 1).should == false
       @space.place_tower("GammaTower", 260, 480, 1).should == false
     end
     
   it "should have a creep wave counter and should send different creep each wave" do
     @space.start
     @space.creep_wave.should == 1
     @space.create_creep(@space.creep_wave)
     @space.creep.last.image_file.should == "images/Creep/creep1.png"
     @space.end_game
     @space.start
     sleep(0.001)
     @space.creep_wave.should == 2
     @space.create_creep(@space.creep_wave)
     @space.creep.last.image_file.should == "images/Creep/creep2.png"
     @space.end_game
   end
   
     it "should only place towers in multiples of 20" do
       @space.place_tower("GammaTower", 240, 240, 1).should == true
       @space.place_tower("GammaTower", 132, 14, 1).should == false
     end
     
   it "should set the tower name by icon clicked correctly" do
     @space.set_tower("GammaTower")
     @space.tower_from_icon.should == "GammaTower"
   end
   
   it "should find the nearest applicable tower placement area" do
     
     x,y = @space.find_nearest_placement(13, 13)
     x.should == 20
     y.should == 20
     x,y = @space.find_nearest_placement(38, 118)
     x.should == 40
     y.should == 120
     x,y = @space.find_nearest_placement(42, 126)
     x.should == 40
     y.should == 120
   end
   
   it "should remove a projectile once it has hit its target or its target is dead" do
     @space.create_creep(@space.creep_wave)
     @space.place_tower("GammaTower", 20,20,1)
     @space.shoot
     @space.projectiles.length.should == 1
     @space.game_clock += 1
     @space.move_projectiles
     @space.move_creep
     @space.game_clock += 1
     @space.move_projectiles
     @space.game_clock += 1
     @space.move_projectiles
     @space.game_clock += 1
     @space.projectiles.length.should == 0
     @space.shoot
     @space.creep.last.take_damage(10)
     @space.creep.last.alive?.should == false
     @space.move_projectiles
     @space.projectiles.length.should == 0
   end
   
   it "should remove a projectile if it has timed out" do
     @space.creep = []
     @space.towers = []
     @space.create_creep(@space.creep_wave)
     creep = @space.creep.last
     @space.place_tower("GammaTower", 200,200,1)
     creep.x = 260
     creep.y = 240
     @space.towers.last.can_shoot?(creep).should == true
     @space.shoot
     3.times {@space.game_clock += 1 and @space.move_creep}
     10.times {@space.move_projectiles and @space.game_clock += 1}
     @space.projectiles.length.should == 0
   end
     
   it "should remove a dead creep" do
     @space.creep = []
     @space.create_creep(@space.creep_wave)
     @space.creep.length.should == 1
     @space.stub!(:path)
     @space.move_creep
     @space.creep.last.take_damage(10)
     sleep(0.51)
     @space.move_creep
     @space.creep.length.should == 0
   end
   
   it "should update the bank when it a creep is killed" do
     @space.money.bank = 10
     @space.creep = []
     @space.create_creep(@space.creep_wave)
     @space.move_creep
     @space.creep.last.take_damage(10)
     sleep(0.51)
     @space.move_creep
     @space.creep.length.should == 0
     @space.money.bank.should == 11
   end
   
   it "should have a number of lives when a game is created" do
     @space.lives.lives_left?.should == true
   end
   
   it "should subtract lives each time a creep makes it to the end" do
     @space.create_creep(1)
     @space.creep.last.x = 488
     @space.creep.last.y = 488
     lives_left = @space.lives.lives
     until @space.creep.last.escaped? == true do
      @space.move_creep 
     end
     @space.move_creep
     @space.creep.length.should == 0
     @space.lives.lives.should == lives_left - 1
   end
   
   it "should end the game when you run out of lives" do
     @space.lives.lives = 1
     @space.create_creep(1)
     @space.creep.last.x = 488
     @space.creep.last.y = 488
     lives_left = @space.lives.lives
     @space.move_creep until @space.creep.last.escaped? == true
     @space.move_creep
     @space.lives.lives_left?.should == false
     @space.game_over?.should == true
   end
   
   it "should have a creep counter that releases creep and counts down" do
     @space.creep_countdown = 20
     @space.create_creep(@space.creep_wave)
     @space.creep_countdown.should == 19
   end
   
   it "should only allow the placing of towers that can be bought" do
     @space.money.bank = 10
     @space.towers = []
     @space.place_tower("GammaTower",40,40,1).should == true
     @space.money.bank.should == 0
     @space.place_tower("GammaTower",80,40,1).should == false
     @space.money.bank.should == 0
   end
   
   it "should have towers shoot their targets, if they have one, first" do
     time = Time.now - 10
     @space.creep = []
     @space.create_creep(@space.creep_wave)
     @space.create_creep(@space.creep_wave)
     @space.place_tower("GammaTower",40,40,1).should == true
     @space.creep.last.x = 45
     @space.creep.last.y = 25
     @space.creep[0].x = 35
     @space.creep[0].y = 25
     @space.money.bank = 10
     @space.towers.last.target = @space.creep.last
     @space.shoot
     @space.move_creep
     @space.towers.last.last_fired = -10
     @space.shoot
     @space.move_projectiles
     @space.creep.last.alive?.should == false
   end
   
    it "should check for blocking" do
      x=40
      (0..440).step(40) {|y| @space.path.add(Block.new(x,y))}
      tower = mock("tower")
      tower.stub!(:x).and_return(80)
      tower.stub!(:y).and_return(460)
      @space.check_for_blocking(tower).should == true
      tower.stub!(:y).and_return(200)
      @space.check_for_blocking(tower).should == false
    end
       
   it "should not allow a tower to be placed on a creep" do
     @space.create_creep(@space.creep_wave)
     @space.creep.last.x = 40
     @space.creep.last.y = 40
     @space.place_tower("GammaTower",40,40,1).should == false
     @space.place_tower("GammaTower",80,40,1).should == true  
   end
   
   it "should not allow creeps to move into towers" do
     @space.place_tower("GammaTower",40,40,1).should == true
     @space.create_creep(@space.creep_wave)
     @space.creep.last.x = 24
     @space.creep.last.y = 24
     @space.move_creep
     @space.creep.last.x.should_not >= 25 if @space.creep.last.y >= 25
   end
   
   it "should have creep move towards their node" do
     @space.create_creep
     creep = @space.creep.last
     node = Path::Node.new(200, 20)
     node.value = 30
     node.add(@space.path.nodes[1])
     node.next_node = @space.path.nodes[1]
     @space.path.nodes << node
     @space.path.nodes[1].value = 0
     @space.path.nodes[0].value = 600
     @space.path.valued = true
     @space.creep_node[creep] = @space.path.add_creep_node(creep.x, creep.y)
     @space.creep_node[creep].next_node = node
     creep.x = 15
     creep.y = 20
     @space.move_creep
     creep.x.should == 15 + creep.move_speed
   end
     
  it "should have creep move in the best direction" do
    @space.create_creep
    creep = @space.creep.last
    creep.x = 10
    creep.y = 10
    @space.place_tower("GammaTower",40,40,1).should == true 
    @space.place_tower("GammaTower",80,40,1).should == true 
    @space.place_tower("GammaTower",120,40,1).should == true 
    @space.move_creep
    @space.creep_node[creep].next_node.x.should == 40-CREEP_RADIUS
    creep.x.should == 11
    creep.y.should == 13
  end
  
  it "should be able to upgrade a tower" do
        @space.place_tower("GammaTower", 40,40,1).should == true
        bank = @space.money.bank
        damage = @space.towers.last.damage
        @space.upgrade_tower(@space.towers.last)
        @space.money.bank.should == bank - Tower::GammaTower.cost[2]
        @space.towers.last.damage.should > damage
      end
      
      it "should be able to sell a tower" do
        @space.place_tower("GammaTower", 40,40,1).should == true
        bank = @space.money.bank
        @space.sell_tower(@space.towers.last)
        
        @space.towers.length.should == 0
        @space.path.obsticals.length.should == 0
        @space.path.nodes.length.should == 2
        @space.money.bank.should == bank + (Tower::GammaTower.cost[1] / 1.5)
      end
      
      it "should sell by adding the cost of all upgrades and putting half that in bank" do
        @space.place_tower("GammaTower", 40,40,1).should == true
        @space.upgrade_tower(@space.towers.last)
        bank = @space.money.bank
        @space.sell_tower(@space.towers.last)
        @space.money.bank.should == bank + (Tower::GammaTower.cost[2] + Tower::GammaTower.cost[1]) / 1.5
      end
      
      it "should send towers with splash a list of close creep when shooting" do
        @space.place_tower("GammaTower", 40,40,1).should == true
        3.times {@space.create_creep()}
        3.times {|i| @space.creep[i].x = 20 + i*2 ; @space.creep[i].y = 20 + i*2}
        health = @space.creep.last.health
        @space.shoot
        5.times {@space.move_projectiles and @space.game_clock += 1}
        @space.projectiles.length.should == 0
        @space.creep[0].health.should == health - @space.towers.last.damage
        @space.creep[1].health.should == health - @space.towers.last.class.splash_damage[1]
      end
        
      it "should display the next creep" do
        @space.space_frame.should_receive(:display_next_creep).with("images/Creep/creep1.png")
        @space.display_next_creep    
      end
      
      it "should have towers wake up for every new wave" do
        @space.place_tower("GammaTower", 40,40,1).should == true
        @space.create_creep()
        creep = @space.creep.last
        creep.x = 400
        creep.y = 400
        @space.game_clock = 2
        random_clock = 2
        @space.towers.last.is_time_to_shoot?(random_clock).should == true
        @space.shoot
        @space.towers.last.is_time_to_shoot?(random_clock).should == false
        @space.init_next_wave
        @space.towers.last.is_time_to_shoot?(random_clock).should == true
      end
end
  