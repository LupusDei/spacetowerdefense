
class Space
  require 'profiler'
  TOP_MARGIN = 53
  LEFT_MARGIN = 53
  MOVE_MULTIPLIER = 3
  CLOCK = 28
  attr_accessor :creep, :towers, :tower_from_icon, :space_frame, :projectiles, :creep_countdown
  attr_accessor :money, :path, :creep_wave, :thread, :creep_list, :pause, :lives, :creep_node, :game_clock

  def new_game(space_frame)
    @space_frame = space_frame
    @space_frame.play_sound("sounds/piano.au") if @space_frame.sound_option == true
    @thread.kill if @thread != nil
    @creep = []
    @creep_wave = 0
    @towers = []
    @projectiles = []
    @tower_from_icon = nil
    @creep_countdown = 15
    @money = Money.new(50)
    @lives = Lives.new(10)
    @path = Path.new
    @pause = false
    @remaining_creep = []
    @creep_node = {}
    @clock_difference = Time.now
    @game_clock = Time.now - @clock_difference
  end
  
  def place_lots_of_towers
    y = 20
    first = true
    (20..440).step(80) do |y|
      if first
        (0..440).step(40) do |x|
          place_tower_now("KineticTower", x, y, 1)
        end
        first = false
      else
        460.step(20,-40) do |x|
          place_tower_now("KineticTower", x, y, 1)
        end
        first = true
      end
    end
  end
    
  def start()
    if @thread != nil
      if @creep_countdown > 0
        @remaining_creep << @creep_countdown
        @remaining_creep << @creep_wave
      end
      @thread.kill
    end
    init_next_wave
    time_to_end = false
    sound = CreepList.get_sound(@creep_wave)
    @space_frame.play_sound(sound) if @space_frame.sound_option == true
    @thread = Thread.start do
          # Profiler__::start_profile
      begin
        loop do
          while @pause
            sleep(0.1)
            @clock_difference = Time.now
          end
          win_the_game?
          break if game_over?
          break if time_to_end == true
          @game_clock += (Time.now - @clock_difference) <= 0.4 ? (Time.now - @clock_difference) : 0.4  
          @clock_difference = Time.now
          finish_making_creep if @remaining_creep.length > 0
          create_creep(@creep_wave) if @creep_countdown > 0
          shoot
          move_projectiles
          sleep(0.04)
          move_creep
          place_tower_now(@tower_name,@tower_x,@tower_y,@tower_level) if @to_be_built
          sell_tower_now(@tower_to_be_sold) if @to_be_sold
          @space_frame.update_all
          tick_countdown(@wave_countdown_clock - @game_clock)
          time_to_end = true if (@wave_countdown_clock - @game_clock) <= 0
        end
        Thread.start {start} if time_to_end == true
        time_to_end = false
      rescue Exception => e
        puts e
        puts e.backtrace
      end
      # Profiler__::stop_profile
      # Profiler__::print_profile($stdout)
    end

    @money.collect_interest

  end
  
  def end_game
    @thread.kill
  end
  
  def init_next_wave
    @creep_countdown = 15
    @creep_wave += 1
    display_next_creep
    @clock_difference = Time.now
    @wave_countdown_clock = @game_clock + CLOCK + @creep_wave / 2
    reset_tower_cooldown
  end
  
  
  def game_over?
    if @lives.lives_left? == false
      @space_frame.game_over
      return true
    end
    return false
  end
  
  def win_the_game?
    if @creep_wave > 29 and @creep.length == 0 and (@wave_countdown_clock - @game_clock) > 2
      @space_frame.play_sound("sounds/siren_2.au") if @space_frame.sound_option == true
      @space_frame.win
      @thread.kill
    end
  end
  
  def tick_countdown(clock)
    @space_frame.tick_countdown(CLOCK - clock)
  end
  
  def display_next_creep
    @space_frame.display_next_creep(CreepList.get_wave(@creep_wave + 1).image_file) if @creep_wave < 26
  end
  
  def finish_making_creep
    length = @remaining_creep.length
    0.step(length-1, 2) do |x| 
      create_creep(@remaining_creep[x+1])
      @remaining_creep[x] += -1
    end 
    a = []
    @remaining_creep.each do |i|
      a << @remaining_creep.index(i) if i == 0
    end
    while a.length > 0
      @remaining_creep.delete_at(a[0]+1)
      @remaining_creep.delete_at(a[0])
      a.delete_at(0)
    end
  end

  def move_projectiles
    @projectiles.each do |projectile|
      if projectile.is_done?
        @space_frame.remove_projectile(projectile)
        @projectiles.delete(projectile)
      else
        time_to_move = projectile.is_time_to_move?(@game_clock)
        projectile.direct_projectile(@game_clock) if time_to_move == true
        if projectile.class.name == "Projectile::PhasePulse" and time_to_move == true
          pen = @space_frame.pen
          pen.color = 'orange'
          pen.width = projectile.strength
          (projectile.wave_x.length - 1).times do |i|
            x1 = LEFT_MARGIN + projectile.wave_x[i]
            x2 = LEFT_MARGIN + projectile.wave_x[i+1]
            pen.draw_line(x1,projectile.wave_y[i],x2,projectile.wave_y[i+1])
          end
        end
      end
    end
  end
  
  def move_creep
    @creep.each do |creep|
      if creep.alive? and creep.escaped? == false
        move_this(creep) if creep.is_time_to_move?(@game_clock)
      else
        kill_creep(creep)
        @path.remove_creep_node(@creep_node[creep])
        @creep_node.delete(creep)
        @space_frame.play_sound("sounds/cork.au") if not creep.has_sound_played? and @space_frame.sound_option == true
        creep.sound_played
      end
    end
  end

  def kill_creep(creep)
    if creep.removable? == true
      @money.bank += creep.kill_val if creep.escaped == false
      @lives.lost_life if creep.escaped == true
      @creep.delete(creep)   
      @space_frame.kill_creep(creep)
    end
  end
  
  def reset_tower_cooldown
    @towers.each do |tower|
      tower.sleep_for(-10)
    end
  end

  def shoot
    @towers.each do |tower|
      nearest_creep = nil
      if tower.is_time_to_shoot?(@game_clock)
        if tower.class.name == "Tower::ImprobabilityTower" or tower.class.name == "Tower::TimeWrappingTower"
          random_creep = rand(@creep.length)
          tower.target = @creep[random_creep]
        end
        if not tower.target.nil? and tower.target.alive? and tower.target.escaped? == false
          launch_projectile(tower, tower.target) if tower.can_shoot?(tower.target)
        else 
          @creep.each do |creep|
            nearest_creep = creep if nearest_creep.nil? or distance_to_tower(creep,tower) < distance_to_tower(nearest_creep,tower)
            if tower.can_shoot?(creep)
              launch_projectile(tower,creep)
              break
            end
          end 
          if tower.is_time_to_shoot?(@game_clock) and nearest_creep != nil
            move_speed = 3
            turns_to_arrive = (get_distance(nearest_creep.x,nearest_creep.y, tower.x,tower.y) - tower.range * 20) / move_speed
            turns_per_second = (1/15.0)
            time_to_sleep =  Math.sqrt((turns_to_arrive * turns_per_second)**2 )
            time_to_sleep = 9 if time_to_sleep > 9
            tower.sleep_for(time_to_sleep)
          end
        end
      end
    end
  end
  
  def distance_to_tower(creep,tower)
    sum = (tower.x - creep.x)**2 + (tower.y - creep.y)**2
    return sum
  end
    
  def launch_projectile(tower,creep)
    sound = TowerList.get_shooting_sound(tower.class.name)
    @space_frame.play_sound(sound) if @space_frame.sound_option == true
    if tower.class.splash_damage.nil?
      @projectiles << tower.fire_projectile(creep, @game_clock)
    else
      @projectiles << tower.fire_projectile(creep,@game_clock, get_close_creep(creep))
    end
    @space_frame.create_projectile(@projectiles.last)
  end

  def get_close_creep(creep1, range = 15)
    close_creep = []
    @creep.each do |creep|
      next if creep == creep1
      if creep1.x >= (creep.x - range) and creep1.x <= (creep.x + range)
        if creep1.y >= (creep.y - range) and creep1.y <= (creep.y + range)
          close_creep << creep
        end
      end
    end
    return close_creep
  end
  
  def upgrade_tower(tower)
    max_level = tower.class.damage.length - 1
    if tower.level < max_level
      if @money.buy(tower.class.cost[tower.level + 1])
        tower.upgrade
      end
    end
  end
  
  def sell_tower(tower)
    @to_be_sold = true
    @tower_to_be_sold = tower
    sell_tower_now(tower) if @thread.nil?
  end
  
  def sell_tower_now(tower)
    @to_be_sold = false
    @towers.delete(tower)
    the_tower = Block.new(tower.x,tower.y)
    @path.obsticals.each  {|obstical| @path.delete_obstical(obstical) if the_tower.top_left == obstical.top_left}
    @path.find_path
    cost = 0
    tower.level.times {|level| cost += tower.class.cost[level + 1] if (level + 1) <= 4}
    @money.sell(cost)
  end

  def place_tower(tower_name,x,y,level)
    @to_be_built = true
    @tower_name = tower_name
    @tower_x = x
    @tower_y = y
    @tower_level = level
    place_tower_now(tower_name,x,y,level) if @thread.nil?
  end
  
  def place_tower_now(tower_name, x, y, level)
     @to_be_built = false
    return false if x < 40 and y < 20
    return false if not TowerList.enough_money?(@money, tower_name)
    return false if check_if_outside_space?(x,y) == false
    @towers.each do |tower|
      return false if check_if_stacking?(tower,x,y) == false
    end
    tower1 = Tower::GammaTower.new(x,y,level)
    return false if tower1.placed? == false
    return false if on_creep?(tower1)
    return false if check_for_blocking(tower1)
    @creep_node = {}
    tower = TowerList.get_tower(tower_name,x,y,level)
    @money.buy(tower.class.cost[level])
    @towers << tower
    @space_frame.place_tower(@towers.last)
    return true
  end
  
  def on_creep?(tower)
    @creep.each do |creep|
      if (creep.x + 15) >= tower.x and (creep.x) <= (tower.x + 40)
        return true if (creep.y + 15) >= tower.y and creep.y <= (tower.y + 40)
      end
    end
    return false
  end
  
  def will_be_on_tower?(creep, move)
    @test_creep = Creep::Creep1.new(1) if @test_creep.nil?
    @test_creep.x = creep.x
    @test_creep.y = creep.y
    case move
    when "left" : @test_creep.left
    when "right" : @test_creep.right
    when "down" : @test_creep.down
    when "up" : @test_creep.up
    end
    @towers.each do |tower|
      if (@test_creep.x + 15) >= tower.x and (@test_creep.x) <= (tower.x + 40)
        return true if (@test_creep.y + 15) >= tower.y and @test_creep.y <= (tower.y + 40)        
      end
    end
    return false
  end
  
  def will_hit_wall?(creep,move)
    @test_creep = Creep::Creep1.new(1) if @test_creep.nil?
    @test_creep.x = creep.x
    @test_creep.y = creep.y
    case move
    when "left" : result = @test_creep.left
    when "right" : result = @test_creep.right
    when "down" : result = @test_creep.down
    when "up" : result = @test_creep.up
    end
    return !result
  end
  
  def check_for_blocking(tower)
    @path.add(Block.new(tower.x,tower.y))
    @path.valued = false
    if @path.unreachable?
      @path.delete_obstical(@path.obsticals.last)
      @path.valued = true
      return true
    end
    time = Time.now
    @path.find_path
    @path.nodes.each do |node|
      if node.next_node.nil?
          # puts "NEXTNODE WAS NIL  #{node.x}, #{node.y} value: #{node.value}"
          next
        end
        # puts "this node #{node.x}, #{node.y}   next node  #{node.next_node.x}, #{node.next_node.y} value:#{node.value}"
      end
      # puts "~~~~~~~~~ done ~~~~~~~~~"
    return false
  end

  def check_if_outside_space?(x,y)
    return false if x < 0 or y < 0
    return false if x > 460 or y > 460
    return true
  end
  def check_if_stacking?(tower,x,y)
    if tower.x == (x - 20)
       return false if tower.y == y
       return false if tower.y == (y - 20)
       return false if tower.y == (y + 20)
    elsif tower.x == x
       return false if tower.y == (y - 20)
       return false if tower.y == y
       return false if tower.y == (y + 20)
    elsif tower.x == (x + 20)
      return false if tower.y == (y + 20)
      return false if tower.y == (y - 20)
      return false if tower.y == y
    end
    return true
  end

  def set_tower(tower_name)
    
    @tower_from_icon = tower_name
  end


  def find_nearest_placement(x, y)
    x = (x / 20.0).round * 20
    y = (y / 20.0).round * 20
    return x,y
  end
  
  def move_this(creep)
    if @creep_node[creep].nil?
      @creep_node[creep] = @path.add_creep_node(creep.x,creep.y)
    end
    if creep.y < 0
      creep.y += 3
      return
    end
    xcenter,ycenter = creep.get_center
    @creep_node[creep].x = xcenter
    @creep_node[creep].y = ycenter
    @path.navigate_creep(@creep_node[creep])
    creep.move_towards(@creep_node[creep].next_node.x, @creep_node[creep].next_node.y, @game_clock) if not @creep_node[creep].next_node.nil?
  end

  
  def get_distance(x1,y1,x2,y2)
    return Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
  end
  
  def create_creep(wave = @creep_wave)
    @creep << CreepList.get_wave(wave)
    @space_frame.create_creep(@creep.last)
    @creep_countdown -= 1
  end
end
