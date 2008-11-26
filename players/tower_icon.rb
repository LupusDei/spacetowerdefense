module TowerIcon
  
  def mouse_clicked(e)
    @space_frame = scene.find("space_frame")
    @space_frame.set_tower(self.id)
    set_tower_info
  end
  
  def set_tower_info
    panel = scene.find("tower_info")
    tower = get_tower(self.id)
    level = tower.level
    panel.text = "#{self.id.to_s} Info     \n Level: #{level}\n Cost: #{tower.class.cost[level]}\n  Damage: #{tower.class.damage[level]}\n Range: #{tower.class.range[level]}\n" +
    " Attack Speed: #{tower.class.attack_speed[level]} \n #{@special}"
   # panel.update
  end
  def get_tower(id)
    case id
    when "GammaTower" : tower = ::Tower::GammaTower.new(0,0,1) and @special = "Splash Damage \n of #{tower.class.splash_damage[1]}"
    when "KineticTower" : tower = ::Tower::KineticTower.new(0,0,1) and @special = nil
    when "GravityTower" : tower = ::Tower::GravityTower.new(0,0,1) and @special = "Melee Splash Damage\n of #{tower.class.splash_damage[1]}\n 10% Chance to Stun"
    when "HotNeedleOfInquiry" : tower = ::Tower::HotNeedleOfInquiry.new(0,0,1) and @special = nil
    when "ImprobabilityTower" : tower = ::Tower::ImprobabilityTower.new(0,0,1) and @special = "Has unlimited range\n Does a random damage:  \n0 to the said damage\n Random Attack Speed: \n0 - said speed"
    when "TimeWrappingTower" : tower = ::Tower::TimeWrappingTower.new(0,0,1) and @special = "Has unlimited range\n Slows creep for two seconds"
    when "DimensionalPhaseTower" : tower = ::Tower::DimensionalPhaseTower.new(0,0,1) and @special = nil
    end
    return tower
  end
end