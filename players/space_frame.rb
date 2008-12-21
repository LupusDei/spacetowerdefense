
module SpaceFrame
  LEFT_CLICK = 1
  RIGHT_CLICK = 3
  TOP_MARGIN = 53
  LEFT_MARGIN = 53
  attr_accessor :space, :selected_tower_prop, :sound_option
  
  def self.extended(prop)
    prop.new_game
  end

  def new_game
    if not @space.nil?
      @space.thread.kill if not @space.thread.nil?
    end
    @space = nil
    self.remove_all
   # update
    @sound_option = true if @sound_option.nil?
    @space = Space.new
    @space.new_game(self)
    update_misc
    tick_countdown(0)
  end
  def start
    @space.start() if @space != nil
  end
  def update_all
    update_creeps
    update_towers
    update_misc
    if @refresher.nil?
      build do
        refresher :id => "refresher"
      end
      @refresher = scene.find("refresher")
    end
    add(@refresher)
    remove(@refresher)
    update_projectiles
  end
  
  def update_creeps
    @space.creep.each do |creep|
      creep.update_prop
    end
  end
  
  def update_towers
    @space.towers.each do |tower|
      tower.update_prop
    end
  end
  
  def update_projectiles
    @space.projectiles.each do |projectile|
      projectile.update_prop
    end
  end
  
  def win
    win_screen = scene.find("win_screen")
    win_screen.style.width = '300'
    win_screen.style.height = '300'
    win_screen.text = "Congratulations! You actually won!  Now the world is saved, thank you!  Where as you assumed this was just a game... You actually just slaughtered many evil space beings trying to eat the Earth! Well done Mr. Wiggins"
    #win_screen.update
  end
  
  def display_next_creep(image)
    container = scene.find("next_creep_display")
    container.style.background_image = image
   # container.update
  end
  
  def tick_countdown(dif)
    label = scene.find("wave_countdown")
    time = (Space::CLOCK - dif).to_i
    label.text = "Next Creep Wave in: #{time}"
  end
  
  def update_misc
    update_money
    update_waves
    update_lives
  end
  
  def update_money
    label = scene.find("money_label")
    label.text =  "Money: #{@space.money.bank.to_i}"
    #label.update
  end
  
  def update_waves
    label = scene.find("wave_label")
    label.text = "Wave: #{@space.creep_wave}"
    #label.update
  end
  
  def update_lives
    label = scene.find("lives_label")
    label.text = "Lives: #{@space.lives.lives}"
    #label.update
  end
  
  def game_over
    label = scene.find("game_over_message")
    label.style.width = '200'
    label.style.height = '150'
    label.text = "Game Over Man!  Mahhnn... you are one pathetic looser!"
    #label.update
  end
  
  def kill_creep(creep)
    remove(creep.prop)
  end
  
  def remove_projectile(projectile)
    remove(projectile.prop)
 #there was an update now here, and regular update or no update i get a null pointer exception a lot
  end
  
  def create_creep(creep)
    creep_prop = Limelight::Prop.new(:name => "creep")
    creep.set_prop(creep_prop)
    add(creep_prop)
  end
  
  def place_tower(tower)
    tower_prop = Limelight::Prop.new(:name => "tower", :tower_reference => tower)
    tower.set_prop(tower_prop)
    add(tower_prop)
    update_all if @space.thread.nil?
  end
  
  def create_projectile(projectile)
    projectile_prop = Limelight::Prop.new(:name => "projectile")
    projectile.set_prop(projectile_prop)
    add(projectile_prop)
  end
  
  def select_new_tower(tower)
    if not @selected_tower_prop.nil?
      @selected_tower_prop.style.border_width = '0'
    #  @selected_tower_prop.update
    end
    @selected_tower_prop = tower
    return if tower.nil?
      tower.style.border_width = '2'
      tower.style.border_color = '#55dd55'
     # tower.update if @space.thread.nil?
      set_tower_info(tower.tower_reference)
  end
  
  def sell
    return if @selected_tower_prop.nil?
    return if @space.nil?
    @space.sell_tower(@selected_tower_prop.tower_reference)
    remove(@selected_tower_prop)
    @selected_tower_prop = nil
    update_money if @space.thread.nil?
    #update
  end
  
  def upgrade
    return if @selected_tower_prop.nil?
    return if @space.nil?
    tower = selected_tower_prop.tower_reference
    @space.upgrade_tower(tower)
    set_tower_info(tower)
    update_money if @space.thread.nil?
    tower.set_prop(@selected_tower_prop)
    #update if @space.thread.nil?
  end
  
  def set_tower_info(tower)
    panel = scene.find("tower_info")
    level = tower.level
    name_parts = tower.class.name.split("::")
    name = name_parts[1]
    panel.text = "#{name} Info   \n Level: #{level}\n Upgrade Cost: #{tower.class.cost[level + 1]}\nDamage: #{tower.class.damage[level]}\n Range: #{tower.class.range[level]}\n" +
    " Attack Speed: #{tower.class.attack_speed[level]} \n  Upgrade Damage: #{tower.class.damage[level + 1]}" +
    "\n Upgrade Range #{tower.class.range[level + 1]}\n Upgrade AttackSpeed: #{tower.class.range[level + 1]}"
   # panel.update
  end

  def mouse_clicked(e)
    return if @space.nil?
    if e.button == RIGHT_CLICK
      @space.tower_from_icon = nil 
      remove(@mouse_prop) if not @mouse_prop.nil?
      @mouse_prop = nil
      select_new_tower(nil)
      #update if @space.thread.nil?
    end
    return if @space.tower_from_icon.nil?
    return if @mouse_prop.nil?
    x,y = @space.find_nearest_placement(@mouse_prop.style.x.to_i, @mouse_prop.style.y.to_i)
    @space.place_tower(@space.tower_from_icon, x, y , 1)
  end
  
  def set_tower(tower_name)
    return if @space.nil?
    @space.set_tower(tower_name)
    @mouse_prop = scene.find("mouse_follower")
    if @mouse_prop.nil?
      build do
        mouse_follower :id => "mouse_follower"
      end
      @mouse_prop = scene.find("mouse_follower")
    end
    @mouse_prop.style.background_image = "images/towers/" + tower_name + ".png"
  end

  def mouse_moved(e)
    return if @space.nil?
    return if @space.tower_from_icon.nil?
    return if @mouse_prop.nil?
    x,y = @space.find_nearest_placement((e.x.to_i - 73), (e.y.to_i - 23))
    @mouse_prop.style.x = x.to_s
    @mouse_prop.style.y = y.to_s
   # update if @space.thread.nil?
  end
  
end