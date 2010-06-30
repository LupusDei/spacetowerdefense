module Projectile
  MOVE_SLEEP_TIME = 0.075 unless defined?(MOVE_SLEEP_TIME)
  class GammaProjectile
    
    class << self
      attr_accessor :image_file,:move_speed
    end
    
    self.image_file = "images/projectiles/photon_burst.png"
    self.move_speed = 6
    attr_accessor :x, :y, :tower, :creep, :prop, :move_speed,:x_vector,:y_vector,:close_creep, :last_move_time
    
    def initialize(tower,creep, close_creep = [])
      @x = tower.x
      @y = tower.y
      @tower = tower
      @creep = creep
      @close_creep = close_creep
      @move_speed = self.class.move_speed
      @x_vector, @y_vector = predictive_shot
      @last_move_time = nil
    end
    
    def direct_projectile(game_clock = Time.now)
      has_not_yet_moved = nil
      if @last_move_time == has_not_yet_moved
        times_to_move = @move_speed
        move(times_to_move)
      else
        if is_time_to_move?(game_clock)
          times_to_move = how_many_times_it_should_move(game_clock)
          move(times_to_move)
        end
      end
      @last_move_time = game_clock
    end
    
    def move(times_to_move)
      times_to_move.times do
       if is_done? == false
          @x -= @x_vector * 3
          @y -= @y_vector * 3
        end       
      end
      @creep.take_damage(@tower.damage) if hit_creep?
      check_splash_damage if hit_creep?
    end
    
    def how_many_times_it_should_move(game_clock)
      time = game_clock - @last_move_time
      return (time * 10 * @move_speed + 0.5).to_i
    end
    
    def check_splash_damage
      if @close_creep.length > 0
        range = @tower.class.splash_range[@tower.level]
        damage = @tower.class.splash_damage[@tower.level]
        @close_creep.each {|creep| creep.take_damage(damage) if hit_creep?(creep,range)}
      end
    end
    
    def is_done?
      return true if hit_creep? == true or @creep.alive? == false or timed_out? == true
      return false
    end
    def timed_out?
      return true if get_distance(@x,@y,@tower.x,@tower.y) >= (@tower.range * 20 + 20)
      return false
    end
    
    def is_time_to_move?(game_clock = Time.now)
      has_not_yet_moved = nil
      return (game_clock - @last_move_time) >= MOVE_SLEEP_TIME if not @last_move_time == has_not_yet_moved
      return true
    end
    
    def predictive_shot
      creep = @creep.clone
      average_move_speed = @move_speed * (2/3.0)
      distance_per_turn = Math.sqrt(((average_move_speed)**2)*2)
      if get_distance(@tower.x,@tower.y,@creep.x,@creep.y) < distance_per_turn
        x,y = adjust_for_last_move(@creep)
        creep.x += x
        creep.y += y
        return get_unit_vector(@creep)
      elsif get_distance(@tower.x,@tower.y,@creep.x,@creep.y) < (distance_per_turn * 2)
        x,y = adjust_for_last_move(@creep)
        creep.x += x * 2
        creep.y += y * 2
        return get_unit_vector(creep)
      elsif get_distance(@tower.x,@tower.y,@creep.x,@creep.y) < (distance_per_turn * 3)
        x,y = adjust_for_last_move(@creep)
        creep.x += x * 3
        creep.y += y * 3
        return get_unit_vector(creep)
      else
        x,y = adjust_for_last_move(@creep)
        creep.x += x * 4
        creep.y += y * 4
        return get_unit_vector(creep)
      end
    end
    
    def adjust_for_last_move(creep)
      x = 0
      y = 0
      guess = 1
      return guess,guess if creep.last_vector.nil?
      x_vec, y_vec = creep.last_vector
      x = x_vec * creep.move_speed
      y = y_vec * creep.move_speed
      return x,y
    end    
    def hit_creep?(creep = @creep, range = 7)
      if @x >= (creep.x - range) and @x <= (creep.x + range)
        if @y >= (creep.y - range) and @y <= (creep.y + range)
          return true
        end
      end
      return false
    end
    
    def get_unit_vector(creep)
      d = Math.sqrt((@x - creep.x)**2 + (@y - creep.y)**2)
      x = (@x - creep.x) / d.to_f
      y = (@y - creep.y) / d.to_f
      return x,y
    end
    
    def set_prop(prop)
      @prop = prop if prop != nil
      update_prop
    end
    
    def update_prop
      if @prop != nil
        @prop.style.x = @x.to_i.to_s
        @prop.style.y = @y.to_i.to_s
        @prop.style.width = '19'
        @prop.style.height = '19'
        @prop.style.background_image = self.class.image_file
      end
    end
    
    def get_distance(x1,y1,x2,y2)
      return Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
    end
  end
  
  class KineticProjectile < GammaProjectile
    
    class << self
      attr_accessor :image_file,:move_speed
    end
    
    self.image_file = "images/projectiles/kinetic_mass.png"
    self.move_speed = 8
    
    def set_prop(prop)
      @prop = prop
      update_prop
    end
    
    def update_prop
      @prop.style.x = @x.to_i.to_s
      @prop.style.y = @y.to_i.to_s
      @prop.style.width = '10'
      @prop.style.height = '10'
      @prop.style.background_image = self.class.image_file
    end
  end
  
  
  class InquiryFusion
    
    class << self
      attr_accessor :image_file, :fusion1, :fusion2
    end
    
    self.image_file = "images/projectiles/Fusion1.png"
    self.fusion1 = "images/projectiles/Fusion1.png"
    self.fusion2 = "images/projectiles/Fusion2.png"
    
    attr_accessor :x, :y, :tower, :creep, :prop, :image_file
    
    def initialize(tower,creep,x,y)
      @x = x
      @y = y
      @tower = tower
      @creep = creep
      @image_file = self.class.image_file
      @start_time = Time.now
      deal_damage
    end
    
    def is_time_to_move?(game_clock = Time.now)
      true
    end
    
    def direct_projectile(game_clock = Time.now)
      if @image_file == self.class.fusion1
        @image_file = self.class.fusion2
        @prop.style.background_image = @image_file
      else
        @image_file = self.class.fusion1
        @prop.style.background_image = @image_file
      end
    end
    
    def is_done?
      return true if (Time.now - @start_time > 0.25)
      return false
    end
    
    def deal_damage
      range = @tower.range * 20
      damage = @tower.damage
      @creep.take_damage(damage) if hit_creep?(@creep,range)
    end
    
    def hit_creep?(creep = @creep, range = 20)
      range = range + 20
      centerx = @tower.x + 20
      centery = @tower.y + 20
      if creep.x < centerx
        x = creep.x + 16
      else
        x = creep.x
      end
      if creep.y < centery
        y = creep.y + 16
      else
        y = creep.y
      end
      distance = Math.sqrt((centerx - x)**2 + (centery - y)**2)
      return true if distance <= range
      return false
    end
    
    def set_prop(prop)
      @prop = prop
      update_prop
    end
    
    def update_prop
      @prop.style.x = @x.to_i.to_s
      @prop.style.y = @y.to_i.to_s
      @prop.style.width = '20'
      @prop.style.height = '20'
      @prop.style.background_image = @image_file
      @prop.style.transparency = '50'
    end
  end
  
  class GravityCorona < InquiryFusion
    
    class << self
      attr_accessor :image_file, :inner, :outer,:black, :black2, :black3
    end
    self.image_file = "images/projectiles/CoronaInner.png"
    self.inner = "images/projectiles/CoronaInner.png"
    self.outer = "images/projectiles/CoronaOuter.png"
    self.black = "images/projectiles/BlackCorona.png"
    self.black2 = "images/projectiles/BlackCorona2.png"
    self.black3 = "images/projectiles/BlackCorona3.png"
    
    attr_accessor :x, :y, :tower, :creep, :prop,:close_creep, :image_file
    
    def initialize(tower,creep, close_creep, first)
      @tower = tower
      @creep = creep
      @close_creep = close_creep
      @close_creep << creep
      @x = tower.x
      @y = tower.y
      @image_file = "images/projectiles/CoronaInner.png" if first
      @image_file = "images/projectiles/CoronaOuter.png" if !first
      @image_file = self.class.black if @tower.level == 4
      @start_time = Time.now
      deal_damage_with_stun
    end

    def deal_damage_with_stun
      range = @tower.class.splash_range[@tower.level]
      damage = @tower.class.splash_damage[@tower.level]
      @close_creep.each do |creep| 
        if hit_creep?(creep,range)
          creep.take_damage(damage)
          creep.stun if @tower.class.chance_to_stun[@tower.level] >= rand(100) 
        end
      end
    end
    
    def hit_creep?(creep = @creep, range = 30)
      range = range + 20
      centerx = @tower.x + 20
      centery = @tower.y + 20
      if creep.x < centerx
        x = creep.x + 16
      else
        x = creep.x
      end
      if creep.y < centery
        y = creep.y + 16
      else
        y = creep.y
      end
      distance = Math.sqrt((centerx - x)**2 + (centery - y)**2)
      return true if distance <= range
      return false
    end
    
    def direct_projectile(game_clock = Time.now)
      @prop.style.transparency = (@prop.style.transparency.to_i - 10).to_s
      if @tower.level == 4
        @image_file = self.class.black3 if @image_file == self.class.black2 and (Time.now - @start_time) > 0.15
        @image_file = self.class.black2 if @image_file == self.class.black and (Time.now - @start_time) > 0.15
      end
    end
    
    def is_done?
      return true if (Time.now - @start_time > 0.4)
      return false
    end
    
    def set_prop(prop)
      @prop = prop
      update_prop
    end
    
    def update_prop
      @prop.style.x = (@x.to_i - 15).to_s
      @prop.style.y = (@y.to_i - 15).to_s
      @prop.style.width = '70'
      @prop.style.height = '70'
      @prop.style.background_image = @image_file
      @prop.style.transparency = '85'
      @prop.style.transparency = '70' if @tower.level == 4
    end
    
  end
  
  class ImprobabilityProjectile < InquiryFusion
    class << self
      attr_accessor :image_files
    end
    self.image_files = ["images/projectiles/improbability_projectiles/Bone.png",
      "images/projectiles/improbability_projectiles/Ginzer.png",
      "images/projectiles/improbability_projectiles/LightBulb.png",
      "images/projectiles/improbability_projectiles/Rabbit.png",
      "images/projectiles/improbability_projectiles/WheelChair.png",
      "images/projectiles/improbability_projectiles/Lurker.png",
      "images/projectiles/improbability_projectiles/GreenBlob.png",
      "images/projectiles/improbability_projectiles/SpermWhale.png",
      "images/projectiles/improbability_projectiles/BirdFace.png",
      "images/projectiles/improbability_projectiles/Monkey.png",
      "images/projectiles/improbability_projectiles/Micah.png"]
    
    attr_accessor :x, :y, :tower, :creep, :prop, :image_file
    
    def initialize(tower,creep, random_image_index)
      @tower = tower
      @creep = creep
      @x = creep.x
      @y = creep.y
      if random_image_index >= 97
        random_image_index = 10
      else
        random_image_index =  random_image_index / 10
      end
      @image_file = self.class.image_files[random_image_index]
      @start_time = Time.now
      attack(creep)
    end
    
    def attack(creep)
      creep.take_damage(tower.damage)
    end
    
    def set_prop(prop)
      @prop = prop
      update_prop
    end
    
    def update_prop
      @prop.style.x = (@x.to_i).to_s
      @prop.style.y = (@y.to_i).to_s
      @prop.style.width = '25'
      @prop.style.height = '25'
      @prop.style.background_image = @image_file
      @prop.style.transparency = '30'
      @prop.style.transparency = '0' if @image_file == "images/projectiles/improbability_projectiles/Micah.png"
    end
    
    def direct_projectile(game_clock = Time.now)
      @prop.style.transparency = (@prop.style.transparency.to_i + 10).to_s
    end
    
    def is_done?
      return true if (Time.now - @start_time > 0.5)
      return false
    end
  end
    
  class TimeBubble < InquiryFusion
    CENTERING = 2 unless defined?(CENTERING)
    class << self
      attr_accessor :image_file
    end
    self.image_file = "images/projectiles/TimeBubble.png"
    
    attr_accessor :x, :y, :tower, :creep, :prop, :image_file
    
    def initialize(tower,creep)
      @tower = tower
      @creep = creep
      @x = creep.x - CENTERING
      @y = creep.y - CENTERING
      @image_file = self.class.image_file
      @start_time = Time.now
      deal_damage_with_slow
    end
    
    def deal_damage_with_slow
      @creep.take_damage(@tower.damage)
      @creep.slow
    end
    def is_done?
      return true if (Time.now - @start_time > 2)
      return false
    end
    
    def set_prop(prop)
      @prop = prop
      update_prop
    end
    
    def update_prop
      @prop.style.x = ((@creep.x - CENTERING).to_i).to_s
      @prop.style.y = ((@creep.y - CENTERING).to_i).to_s
      @prop.style.width = '19'
      @prop.style.height = '19'
      @prop.style.background_image = @image_file
      @prop.style.transparency = '50'
    end
    
    def direct_projectile(game_clock = Time.now)
      @prop.style.transparency = (@prop.style.transparency.to_i + 3).to_s
      @prop.style.x = (@creep.x.to_i).to_s
      @prop.style.y = (@creep.y.to_i).to_s
    end
      
  end
  
  class PhasePulse < GammaProjectile
    CENTERING = 20 unless defined?(CENTERING)
    
      attr_accessor :x, :y, :tower, :creep, :prop, :wave_x, :wave_y, :strength
    
    def initialize(tower,creep)
      @tower = tower
      @strength = tower.level
      @creep = creep
      @x = tower.x + CENTERING
      @y = tower.y + CENTERING
      @start_time = Time.now
      generate_points(@start_time)
      deal_damage
      @last_move_time = nil
    end
    
    def deal_damage
      @creep.take_damage(@tower.damage)
    end
    
    def generate_points(time)
      @wave_x = []
      @wave_y = []
      offset = rand(10)
      creep_x, creep_y = @creep.get_center
      slope = creep_x != @x ?  (creep_y - @y) / (creep_x - @x).to_f : creep_y - @y 
      distance = get_distance(@x,@y,creep_x,creep_y)
      if (-3..3) === slope
        20.times do |i|
          t = ((creep_x - @x + 0.1) / 20.0) * i
          @wave_x[i] = (@x + ((creep_x - @x)/ 20.0) * i).to_i
          wave_offset = (4 * ((distance)/50)) * Math.sin(t * 2**(-3 + 40/distance) + offset)
          @wave_y[i] = (@y + slope*t * Math.sin(Math::PI/2) + wave_offset).to_i
        end
      else
        slope = (creep_x - @x)/ (creep_y - @y).to_f
        20.times do |i|
          t = ((creep_y - @y) / 20.0) * i
          wave_offset = (4 * ((distance)/50)) * Math.sin(t * 2**(-3 + 40/distance) + offset)
          @wave_x[i] = (@x + Math.cos(0) * (slope) * t + wave_offset).to_i
          @wave_y[i] = (@y + ((creep_y - @y) / 20.0) * i).to_i
        end
      end
    end
    
    def is_done?
      return (Time.now - @start_time) > @tower.attack_speed
    end
    
    def set_prop(prop)
    end

    def update_prop
    end
    
    def direct_projectile(game_clock = Time.now)
      generate_points(game_clock)
      @last_move_time = game_clock
    end
    
  end
    
    
end
