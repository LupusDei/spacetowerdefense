require File.dirname(__FILE__) + '/creep.rb'
class CreepNavigation
  DIRECTIONS = ['up', 'down' , 'left', 'right']
  @@opposites = {'up', 'down' , 'left', 'right', 'down' ,'up', 'right','left'}
  attr_accessor :creep, :towers, :correct_path
  
  class CorrectPath
    attr_accessor :x, :y, :dir
    def initialize(start_x, start_y)
      @x = []
      @y = []
      @dir = []
      @x << start_x
      @y << start_y
    end
  end
  
  def navigate_creep(creep)
    if (creep.path_log == nil)
      puts "here1"
      dist = nil
      keep = nil
      puts @correct_path.x.length
      10.times do |i|
        puts "here blue #{i}"
        dis = get_distance(creep.x,creep.y,@correct_path.x[i],@correct_path.y[i]) 
        dist = dis if dist.nil?
        keep = i if dis < dist
        dist = dis if dis < dist
      end
      puts "here2"
      best = best_direction(creep,@correct_path.x[keep],@correct_path.y[keep])
      puts "here3"
      creep.path_log = keep if best == true 
      puts "here"
      make_move(creep, best) if best != true
    end
    make_move(creep, @correct_path.dir[creep.path_log])
    creep.path_log += 1
  end
  
  def make_move(creep,direction)
    puts direction
    creep.up if direction == "up"
    creep.right if direction == "right"
    creep.down if direction == "down"
    creep.left if direction == "left"
  end
  
  def update_towers(towers)
    @towers = [] if @towers.nil?
    return if @towers == towers
    @towers = towers
  end
  
    
  
  def is_there_blocking?(towers)
    update_towers(towers)
    @correct_path = CorrectPath.new(0,-10)
    path = CorrectPath.new(0, -10)
    creep = Creep::Creep1.new(1)
    creep.x = 0
    creep.y = -10
    direction = best_direction(creep,500,500)
    @correct_path = next_path(path,creep,direction.first)
    return true if path == @correct_path
    return false
  end
  
  def next_path(path1,creep1,direction1)
    path, creep = path1.clone, creep1.clone
    set_path(path,creep,direction1)
    return path if creep.x >= 495 and creep.y >= 495
    length = path.x.length
    (length).times do |i|
      return false if path.x[i] == path.x[length-i] and path.y[i] == path.y[length - i] and (i != length -i)
      return false if path.x[i] == path.x[i+1] and path.y[i] == path.y[i+1] and (i+1 < length)
    end
    best = best_direction(creep,500,500)
    directions = open_directions(creep)
    open = []
    DIRECTIONS.each do |direction|
      open << direction if directions[direction] == true
    end
    open.delete(best)
    return false if open.length == 0  #only path is back where it came from
    
    best_path = best != true ? next_path(path,creep,best) : false
    return best_path if best_path != false
    # if best.length > 1
    #   next_best_path = best[1] != true ? next_path(path,creep,best[1]) : false
    #   return next_best_path if next_best_path != false
    # end
    remaining_paths = []
    open.each do |direction|
      remaining_paths << next_path(path,creep,direction)
    end
    remaining_paths.delete(false)
    return remaining_paths if remaining_paths.length > 0 
    return false
  end
  
  def set_path(path,creep,direction)
    creep.up and path.dir << 'up' and path.x << creep.x and path.y << creep.y if direction == 'up'
    creep.down and path.dir << 'down' and path.x << creep.x  and path.y << creep.y if direction == 'down'
    creep.right and path.dir << 'right' and path.x << creep.x and path.y << creep.y if direction == 'right'   
    creep.left and path.dir << 'left' and path.x << creep.x  and path.y << creep.y if direction == 'left'
  end
  
  def best_direction(creep,x2,y2)
    directions = open_directions(creep)
    directions = check_directions(creep, directions,x2,y2)
    best = nil
    DIRECTIONS.each do |direction|
      if directions[direction] != false and directions[direction] != true
        best = direction if best.nil?
        best = direction if directions[best] > directions[direction]
      end
    end
    return false if best.nil?
    return true if @@opposites[best] == creep.last_move
    return best
  end
    
  def check_directions(creep,directions, x2,y2)
    x = creep.x
    y = creep.y
    creep1 = creep.clone
    if creep1.up == true
      directions['up'] = get_distance(x,y - creep.move_speed,x2,y2 ) if directions['up'] == true
      creep1.down
    end
    if creep1.down == true
      directions['down'] = get_distance(x,y + creep.move_speed,x2,y2) if directions['down'] == true
      creep1.up
    end
    if creep1.right == true
      directions['right'] = get_distance(x + creep.move_speed,y,x2,y2) if directions['right'] == true
      creep1.left
    end
    if creep1.left == true
      directions['left'] = get_distance(x - creep.move_speed,y,x2,y2) if directions['left'] == true
      creep1.right
    end
    return directions
  end
  
  def get_distance(x1,y1,x2,y2)
    return Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
  end
  
  def open_directions(creep)
    directions = {}
    DIRECTIONS.each do |direction|
      directions[direction] = !(hit_tower_if_go?(creep, direction)) 
    end
    return directions
  end
  
  def hit_tower_if_go?(creep1, direction)
    creep = creep1.clone
    @towers.each do |tower|
      return true if direction == 'down' and hit_down?(creep,tower) == true
      return true if direction == 'up' and hit_up?(creep,tower) == true
      return true if direction == 'right' and hit_right?(creep,tower) == true
      return true if direction == 'left' and hit_left?(creep,tower) == true
    end  
    return false
  end 
  
  def hit_down?(creep,tower)
    return true if creep.down == false
    creep.up
    return false if (creep.x >= tower.x and creep.x <= (tower.x + 40)) == false
    y = creep.y
    if ((y + creep.move_speed) >= tower.y) and ((y + creep.move_speed) <= (tower.y + 40))
      return true
    end
    return false
  end    
  
  def hit_up?(creep,tower)
    return true if creep.up == false
    creep.down
    return false if (creep.x >= tower.x and creep.x <= (tower.x + 40)) == false
    y = creep.y
    if ((y - creep.move_speed) >= tower.y) and ((y - creep.move_speed) <= (tower.y + 40))
      return true
    end 
    return false
  end
  
  def hit_right?(creep,tower)
    return true if creep.right == false
    creep.left
    return false if (creep.y >= tower.y and creep.y <= (tower.y + 40)) == false
    x = creep.x
    if ((x + creep.move_speed) >= tower.x) and ((x + creep.move_speed) <= (tower.x + 40))
      return true
    end
    return false
  end
  
  def hit_left?(creep,tower)
    return true if creep.left == false
    creep.right
    return false if (creep.y >= tower.y and creep.y <= (tower.y + 40)) == false
    x = creep.x
    if ((x - creep.move_speed) >= tower.x) and ((x - creep.move_speed) <= (tower.x + 40))
      return true
    end
    return false
  end
  
end