require File.dirname(__FILE__) + '/../projectile/projectile'
module Tower
  
  class GammaTower
    class << self
      attr_accessor :damage, :range, :attack_speed, :image_file, :cost, :splash_range,:splash_damage
    end
    
    self.damage = [0,5,14,40]
    self.range = [0,4,5,6]
    self.attack_speed = [0,2,2,1.5]
    self.cost = [0,10,20,50]
    self.image_file = "images/towers/GammaTower.png"
    self.splash_range = [0,7,10,14]
    self.splash_damage = [0,5,10,33]
    
    attr_accessor :x,:y,:level,:damage,:range,:attack_speed,:prop,:target,:last_fired,:image_file
    
    def initialize(x,y,level)
      if x.divmod(20)[1] ==0 and y.divmod(20)[1] ==0
        @x = x
        @y = y
        @placed = true
        @level = level
        setup_tower
        @last_fired = -10
        @game_clock = 0
        @target = nil
        @image_file = self.class.image_file
      else
        @placed = false
      end
    end
    
    def upgrade
      max_level = self.class.damage.length - 1
      return false if @level == max_level
      @level += 1
      setup_tower
      return true
    end
    
    def placed?
      return @placed
    end
    
    def setup_tower
      @damage = self.class.damage[@level]
      @range = self.class.range[@level]
      @attack_speed = self.class.attack_speed[@level]
    end
    def set_prop(prop)
      if prop != nil
        @prop = prop
        @prop.style.background_image = @image_file
        @prop.style.x = @x.to_s
        @prop.style.y = @y.to_s
      else
        puts "tower prop was nil"
      end
    end
    
    def is_time_to_shoot?(game_clock)
      @game_clock = game_clock
      (game_clock - @last_fired) > attack_speed
    end
    
    def sleep_for(time)
      @last_fired = @game_clock + time - attack_speed * 1.2
    end
    
    def can_shoot?(creep)
      return false if creep.nil?
      if creep.alive?
        if in_range?(creep) == true
          @target = creep
          return true
        end
      end
      return false
    end
    
    def fire_projectile(creep, game_clock, close_creep = [])
      @last_fired = game_clock
      @game_clock = game_clock
      return projectile = Projectile::GammaProjectile.new(self,creep,close_creep)
    end
       
    def in_range?(creep)
      distance = Math.sqrt((@x - creep.x)**2 + (@y - creep.y)**2)
      if distance <= (@range * 20)
        return true
      else
        return false
      end
    end
    
  end
  
  class KineticTower < GammaTower
    
    class << self
      attr_accessor :damage, :range, :attack_speed, :image_file, :cost, :splash_range,:splash_damage
    end
    
    self.damage = [0,3,12,35]
    self.range = [0,6,8,10]
    self.attack_speed = [0,1,1,1]
    self.cost = [0,5,10,30]
    self.image_file = "images/towers/KineticTower.png"
    def fire_projectile(creep,game_clock, close_creep = [])
      @last_fired = game_clock
      projectile = Projectile::KineticProjectile.new(self,creep)
      x = (creep.x - @x)
      y = @y - creep.y
      r = Math.atan(y/x.to_f)
      r = r + Math::PI if x < 0 and y > 0
      r = r + Math::PI if x < 0 and y < 0
      r = r + 2 * Math::PI if x > 0 and y < 0
      case r
      when 0..(Math::PI / 6) : @image_file = "images/towers/kineticTower/KineticTower0.png"
      when (Math::PI / 6)..(Math::PI / 3) :  @image_file = "images/towers/kineticTower/KineticTower30.png"
      when (Math::PI / 3)..(Math::PI / 2) :  @image_file = "images/towers/kineticTower/KineticTower60.png"
      when (Math::PI / 2)..(2 * Math::PI / 3) :  @image_file = "images/towers/kineticTower/KineticTower90.png"
      when (2 * Math::PI / 3)..(5 * Math::PI / 6) :  @image_file = "images/towers/kineticTower/KineticTower120.png"
      when (5 * Math::PI / 6)..(Math::PI) :  @image_file = "images/towers/kineticTower/KineticTower150.png"
      when (Math::PI)..(7 * Math::PI / 6) :  @image_file = "images/towers/kineticTower/KineticTower180.png"
      when (7 * Math::PI / 6)..(4 * Math::PI / 3) :  @image_file = "images/towers/kineticTower/KineticTower210.png"
      when (4 * Math::PI / 3)..(3 * Math::PI / 2) :  @image_file = "images/towers/kineticTower/KineticTower240.png"
      when (3 * Math::PI / 2)..(5 * Math::PI / 3) :  @image_file = "images/towers/kineticTower/KineticTower270.png"
      when (5 * Math::PI / 3)..(11 * Math::PI / 6) :  @image_file = "images/towers/kineticTower/KineticTower300.png"
      when (11 * Math::PI / 6)..(2 * Math::PI) :  @image_file = "images/towers/kineticTower/KineticTower330.png"
      end
      return projectile
    end
  end
  
  class HotNeedleOfInquiry < GammaTower
    
    class << self
      attr_accessor :damage, :range, :attack_speed, :image_file, :cost, :splash_range,:splash_damage
    end
    
    self.damage = [0,4,16,64]
    self.range = [0,1,1.1,1.2]
    self.attack_speed = [0,0.25,0.25,0.25]
    self.cost = [0,10,25,60]
    self.image_file = "images/towers/HotNeedleOfInquiry.png"
    def fire_projectile(creep, game_clock)
      @last_fired = game_clock
      x = ((creep.x + 8) - (@x + 20))
      y = ((@y + 20) - (creep.y + 7))
      r = Math.atan(y/x.to_f)
      r = r + Math::PI if x < 0 and y > 0
      r = r + Math::PI if x < 0 and y < 0
      r = r + 2 * Math::PI if x > 0 and y < 0
      case r
      when (0)..((20 * Math::PI) / 180) : @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry10.png" and x = @x + 39 and y = @y + 10
      when ((20 * Math::PI) / 180)..((40 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry30.png" and x = @x + 38 and y = @y -2
      when ((40 * Math::PI) / 180)..((60 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry50.png" and x = @x + 35 and y = @y - 10 
      when ((60 * Math::PI) / 180)..((80 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry70.png" and x = @x + 22 and y = @y - 16
      when ((80 * Math::PI) / 180)..((100 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry90.png" and x = @x + 10 and y = @y - 18
      when ((100 * Math::PI) / 180)..((120 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry110.png" and x = @x - 5 and y = @y - 16
      when ((120 * Math::PI) / 180)..((140 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry130.png" and x = @x - 12 and y = @y - 10
      when ((140 * Math::PI) / 180)..((160 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry150.png" and x = @x - 15 and y = @y - 2
      when ((160 * Math::PI) / 180)..((180 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry170.png" and x = @x - 18 and y = @y + 8
      when ((180 * Math::PI) / 180)..((200 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry190.png" and x = @x - 17 and y = @y + 13
      when ((200 * Math::PI) / 180)..((220 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry210.png" and x = @x - 15 and y = @y + 25
      when ((220 * Math::PI) / 180)..((240 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry230.png" and x = @x - 10 and y = @y + 35
      when ((240 * Math::PI) / 180)..((260 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry250.png" and x = @x -3 and y = @y + 38
      when ((260 * Math::PI) / 180)..((280 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry270.png" and x = @x + 10 and y = @y + 39
      when ((280 * Math::PI) / 180)..((300 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry290.png" and x = @x + 21 and y = @y + 35
      when ((300 * Math::PI) / 180)..((320 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry310.png" and x = @x + 30 and y = @y + 32
      when ((320 * Math::PI) / 180)..((340 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry330.png" and x = @x + 38 and y = @y + 25
      when ((340 * Math::PI) / 180)..((360 * Math::PI) / 180) :  @image_file = "images/towers/hotNeedleOfInquiry/HotNeedleOfInquiry350.png" and x = @x + 39 and y = @y + 15
      end
      fusion = Projectile::InquiryFusion.new(self,creep,x,y)
      return fusion
    end
    
    def in_range?(creep)
      range = @range * 20 + 20
      centerx = @x + 20
      centery = @y + 20
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
    
  end
  
  class GravityTower < GammaTower
    
    class << self
      attr_accessor :damage, :range, :attack_speed, :image_file, :cost, :splash_range,:splash_damage, :chance_to_stun
    end
    
    self.damage = [0,15,40,90, 200]
    self.range = [0,1.5,1.5,1.5,1.8]
    self.attack_speed = [0,2,1.8,1.5,1]
    self.cost = [0,40,60,80, 150]
    self.image_file = "images/towers/GravityTower/GravityTower.png"
    self.splash_range = [0,30,30,30,37]
    self.splash_damage = self.damage
    self.chance_to_stun = [0,10, 15, 25,35]
    
    def fire_projectile(creep,game_clock, close_creep = [])
      @last_fired = game_clock
      @flip_flop = true if @flip_flop.nil?
      if @flip_flop
        projectile = Projectile::GravityCorona.new(self,creep,close_creep,true)
      else
        projectile = Projectile::GravityCorona.new(self,creep,close_creep,false)
      end
      @flip_flop = !@flip_flop
      return projectile
    end
    
    def setup_tower
      @damage = self.class.damage[@level]
      @range = self.class.range[@level]
      @attack_speed = self.class.attack_speed[@level]
      case @level
      when 2 : @image_file = "images/towers/GravityTower/GravityTower2.png"
      when 3 : @image_file = "images/towers/GravityTower/GravityTower3.png"
      when 4 : @image_file = "images/towers/GravityTower/BlackHole.png"
      end
    end
    
    def in_range?(creep)
      range = @range * 20 + 20
      centerx = @x + 20
      centery = @y + 20
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
  end
  
  class ImprobabilityTower < GammaTower
    AMOUNT_OF_IMAGES = 10 if not defined?(AMOUNT_OF_IMAGES)
    DAMAGE1 = 18
    DAMAGE2 = 42
    DAMAGE3 = 150
    ATTACK1 = 5
    ATTACK2 = 3.5
    ATTACK3 = 2
    class RandomNumberGenerator
      def get(range)
        return rand(range)
      end
    end
    
    class << self
      attr_accessor  :range, :image_file,:damage, :attack_speed, :cost,:rand_num, :splash_range,:splash_damage
    end
    self.rand_num = RandomNumberGenerator.new
    self.damage = [0,DAMAGE1,DAMAGE2,DAMAGE3]
    self.range = [0,0,0,0]
    self.attack_speed = [0,ATTACK1,ATTACK2,ATTACK3]
    self.cost = [0,15,42,80]
    self.image_file = "images/towers/ImprobabilityTower.png"
    
    def damage
      return self.class.rand_num.get(self.class.damage[@level])
    end
    
    def fire_projectile(creep,game_clock)
      @last_fired = game_clock
      random_image_index = self.class.rand_num.get(AMOUNT_OF_IMAGES * 10)
      projectile = Projectile::ImprobabilityProjectile.new(self, creep, random_image_index)
      @attack_speed = self.class.rand_num.get(self.class.attack_speed[@level])
      return projectile
    end
    
    def in_range?(creep)
      creep_is_always_in_range = true
      return creep_is_always_in_range
    end
    
  end
  
  class TimeWrappingTower < ImprobabilityTower
    
    class << self
      attr_accessor  :range, :image_file, :attack_speed, :cost,:rand_num, :splash_range,:splash_damage
    end
    self.rand_num = RandomNumberGenerator.new
    self.damage = [0,5,20,50]
    self.range = [0,0,0,0]
    self.attack_speed = [0,2,1.5,1]
    self.cost = [0,15,30,60]
    self.image_file = "images/towers/TimeWrappingTower.png"
    
    def damage
      self.class.damage[@level]
    end
    
    def fire_projectile(creep, game_clock)
      @last_fired = game_clock
      projectile = Projectile::TimeBubble.new(self,creep)
      return projectile
    end
    
  end
  
  class DimensionalPhaseTower < GammaTower
    
    class << self
      attr_accessor  :range, :image_file, :attack_speed, :cost, :splash_range,:splash_damage
    end
    self.damage = [0,6,30,85]
    self.range = [0,5,6,7]
    self.attack_speed = [0,0.5,0.5,0.5]
    self.cost = [0,20,40,70]
    self.image_file = "images/towers/DimensionalPhaseTower.png"
    
    
    def fire_projectile(creep,game_clock)
      @last_fired = game_clock
      projectile = Projectile::PhasePulse.new(self,creep)
      return projectile
    end
    
    def in_range?(creep)
      creep_x, creep_y = creep.get_center
      x = @x + 20
      y = @y + 20
      distance =  Math.sqrt((creep_x - x)**2 + (creep_y - y)**2)
      return distance <= (@range * 20 + 20)
    end
      
  end
    
  
end
