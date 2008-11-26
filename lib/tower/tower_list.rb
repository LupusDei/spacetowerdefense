module TowerList
  
  def self.get_tower(tower_name,x=0,y=0,level=1)
    case tower_name
    when "GammaTower" : return Tower::GammaTower.new(x,y,level)
    when "KineticTower" : return Tower::KineticTower.new(x,y,level)
    when "GravityTower" : return Tower::GravityTower.new(x,y,level)
    when "HotNeedleOfInquiry" : return Tower::HotNeedleOfInquiry.new(x,y,level)
    when "ImprobabilityTower" : return Tower::ImprobabilityTower.new(x,y,level)
    when "TimeWrappingTower" : return Tower::TimeWrappingTower.new(x,y,level)
    when "DimensionalPhaseTower" : return Tower::DimensionalPhaseTower.new(x,y,level)
    end
  end
  
  def self.enough_money?(money, tower_name)
    tower = TowerList.get_tower(tower_name)
    return money.can_buy?(tower.class.cost[1])
  end
  
  def self.get_shooting_sound(tower_name)
    case tower_name
    when "Tower::GammaTower" : return "sounds/Oomph.au"
    when "Tower::KineticTower" : return "sounds/Gun-1.au"
    when "Tower::GravityTower" : return "sounds/beep_bassoon_and_bone.au"
    when "Tower::HotNeedleOfInquiry" : return "sounds/buzzer.au"
    when "Tower::ImprobabilityTower" : return "sounds/cow_2.au"
    when "Tower::TimeWrappingTower" : return "sounds/beep_metal.au"
    when "Tower::DimensionalPhaseTower" : return "sounds/WoodWordsC3.au"
    end
  end
end
