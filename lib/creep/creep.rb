module Creep
  SPEED = 3 unless defined?(SPEED)
  CREEP_RADIUS = 8 unless defined?(CREEP_RADIUS)
  MOVE_SLEEP_TIME = 0.075 unless defined?(MOVE_SLEEP_TIME)
  class Creep1
    
    class << self
      attr_accessor :health, :kill_val, :image_file, :move_speed
    end
    
    self.health = [0,10,110,450,1130]
    self.kill_val = [0,1,2,3,5]
    self.image_file = "images/Creep/creep1.png"
    self.move_speed = SPEED
    attr_accessor :level, :health, :kill_val, :x, :y, :prop, :last_vector, :move_speed, :image_file,:last_move_time ,:escaped
    
    def initialize(level)
      if level < 1
puts "you can't have such low level creep"
        break
      end
      @level = level
      setup_creep
      @x = rand(20)
      @y = rand(10) * -1
      @alive = true
      @removable = 0
      @escaped = false
      @last_vector = nil
      @last_move_time = nil
      @stun_time = Time.now
      @slow_time = Time.now
      @sound_played = false
    end
    
    def setup_creep
      @health = self.class.health[@level]
      @kill_val = self.class.kill_val[@level]
      @move_speed = self.class.move_speed
      @image_file = self.class.image_file
    end
    
    def take_damage(damage)
      @health -= damage
      @alive = false if @health < 1
      splat if @alive == false
    end
    
    def alive?
      @move_speed = self.class.move_speed if (Time.now - @stun_time) >= 1 and (Time.now - @slow_time) >= 2
      return @alive
    end
     
    def sound_played
      @sound_played = true
    end
    def has_sound_played?
      return @sound_played
    end
    def splat
      @image_file = "images/Creep/splat.png"
      @remove_time = Time.now
    end
    
    def removable?
      if alive? == false
        if @remove_time + 0.3 < Time.now
          return true
        end
      end
      return @escaped
    end
    
    def escaped?
      x_center, y_center = get_center
       @escaped = true if x_center >= 496 and y_center >= 496
       @escaped
    end
    
    def set_prop(prop)
      if prop != nil
        @prop = prop
        @prop.style.background_image = @image_file
        @prop.style.x = @x.to_i.to_s
        @prop.style.y = @y.to_i.to_s
      end
    end
    
    def stun
      @stun_time = Time.now
      @move_speed = 0
    end
    
    def slow
      @slow_time = Time.now
      @move_speed = @move_speed / 2
    end
    
    def move_towards(x,y, time)
      x_vec, y_vec = get_unit_vector(x,y)
      x_center, y_center = get_center
      has_not_yet_moved = nil
      if @last_time_moved == has_not_yet_moved
        set_center(x_center + (x_vec * @move_speed + 0.5).to_i, y_center + (y_vec * @move_speed + 0.5).to_i)
      else
        if is_time_to_move?(time)
          distance = move_distance(time)
          set_center(x_center + (x_vec * distance + 0.5).to_i, y_center + (y_vec * distance + 0.5).to_i)
        end
      end
      @last_time_moved = time
      @last_vector = x_vec, y_vec
    end
    
    def is_time_to_move?(game_clock)
       return (game_clock - @last_time_moved) >= MOVE_SLEEP_TIME if not @last_time_moved.nil?
      return true
    end
    
    def move_distance(game_clock)
      time = game_clock - @last_time_moved
      return time * 10 * @move_speed
    end
    
    def get_center
      return @x + CREEP_RADIUS, @y + CREEP_RADIUS
    end
    
    def set_center(x_center, y_center)
      @x = x_center - CREEP_RADIUS
      @y = y_center - CREEP_RADIUS
    end
    
    def get_unit_vector(x_goal, y_goal)
      x_center, y_center = get_center
      d = Math.sqrt((x_center - x_goal)**2 + (y_center - y_goal)**2)
      return 0,0 if d == 0
      x = (x_goal - x_center) / d.to_f
      y = (y_goal - y_center) / d.to_f
      return x,y
    end
    
    def up
      if (@x <= 20 and @y >= (-20 + @move_speed)) or @y >= ( 0 + @move_speed)
        @y -= @move_speed
        return true
      end
      return false
    end
    def down
      return false if @y >= (490 - @move_speed) and x <= 480
      if @y <= (503 - @move_speed) 
        @y += @move_speed
        return true
      end
      return false
    end
    def right
      return false if (@y < 0 and (@x + @move_speed) > 20)
      return false if @x >= (490 - @move_speed) and @y <= 480
      if @x <= (503 - @move_speed)
        @x += @move_speed
        return true
      end
      return false
    end
    def left
      if @x >= (0 + @move_speed)
        @x -= @move_speed
        return true
      end
    return false
    end
    
  end
  
  class Creep2 < Creep1
    
    class << self
      attr_accessor :health, :kill_val, :image_file, :move_speed
    end
    
    self.health = [0,15,140,520,1250]
    self.kill_val = [0,1,2,3,5]
    self.image_file = "images/Creep/creep2.png"
    self.move_speed = SPEED
  end
  class Creep3 < Creep1
    
    class << self
      attr_accessor :health, :kill_val, :image_file, :move_speed
    end
    
    self.health = [0,20,170,590,1380]
    self.kill_val = [0,1,2,3,5]
    self.image_file = "images/Creep/creep3.png"
    self.move_speed = SPEED
  end
  class Creep4 < Creep1
    
    class << self
      attr_accessor :health, :kill_val, :image_file, :move_speed
    end
    
    self.health = [0,25,200,670,1520]
    self.kill_val = [0,1,2,3,5]
    self.image_file = "images/Creep/creep4.png"
    self.move_speed = SPEED
  end
  class Creep5 < Creep1
    
    class << self
      attr_accessor :health, :kill_val, :image_file, :move_speed
    end
    
    self.health = [0,35,240,750,1680]
    self.kill_val = [0,1,2,3,5]
    self.image_file = "images/Creep/creep5.png"
    self.move_speed = SPEED
  end
  class Creep6 < Creep1
    
    class << self
      attr_accessor :health, :kill_val, :image_file, :move_speed
    end
    
    self.health = [0,50,280,840,2000]
    self.kill_val = [0,1,2,3,10]
    self.image_file = "images/Creep/creep6.png"
    self.move_speed = SPEED
  end
  class Creep7 < Creep1
    
    class << self
      attr_accessor :health, :kill_val, :image_file, :move_speed
    end
    
    self.health = [0,65,330,930]
    self.kill_val = [0,1,2,3]
    self.image_file = "images/Creep/creep7.png"
    self.move_speed = SPEED
  end
  class Creep8 < Creep1
    
    class << self
      attr_accessor :health, :kill_val, :image_file, :move_speed
    end
    
    self.health = [0,85,380,1030]
    self.kill_val = [0,1,2,3]
    self.image_file = "images/Creep/creep8.png"
    self.move_speed = SPEED
  end
  
end