
module CreepList
  
  def self.get_wave(wave)
    case wave
    when 0 : return Creep::Creep1.new(1)
    when 1 : return Creep::Creep1.new(1)
    when 2 : return Creep::Creep2.new(1)
    when 3 : return Creep::Creep3.new(1)
    when 4 : return Creep::Creep4.new(1)
    when 5 : return Creep::Creep5.new(1)
    when 6 : return Creep::Creep6.new(1)
    when 7 : return Creep::Creep7.new(1)
    when 8 : return Creep::Creep8.new(1)
    when 9 : return Creep::Creep1.new(2)
    when 10 : return Creep::Creep2.new(2)
    when 11 : return Creep::Creep3.new(2)
    when 12 : return Creep::Creep4.new(2)
    when 13 : return Creep::Creep5.new(2)
    when 14 : return Creep::Creep6.new(2)
    when 15 : return Creep::Creep7.new(2)
    when 16 : return Creep::Creep8.new(2)
    when 17 : return Creep::Creep1.new(3)
    when 18 : return Creep::Creep2.new(3)
    when 19 : return Creep::Creep3.new(3)
    when 20 : return Creep::Creep4.new(3)
    when 21 : return Creep::Creep5.new(3)
    when 22 : return Creep::Creep6.new(3)
    when 23 : return Creep::Creep7.new(3)
    when 24 : return Creep::Creep8.new(3)
    when 25 : return Creep::Creep1.new(4)
    when 26 : return Creep::Creep2.new(4)
    when 27 : return Creep::Creep3.new(4)
    when 28 : return Creep::Creep4.new(4)
    when 29 : return Creep::Creep5.new(4)
    when 30 : return Creep::Creep6.new(4)
    end
  end
  
  def self.get_sound(wave)
    case wave
    when 0 : return "sounds/cat_1.au"
    when 1 : return "sounds/cat_1.au"
    when 2 : return "sounds/whoopee.au"
    when 3 : return "sounds/giggle.au"
    when 4 : return "sounds/puke.au"
    when 5 : return "sounds/yell.au"
    when 6 : return "sounds/siren_1.au"
    when 7 : return "sounds/bart_laugh.au"
    when 8 : return "sounds/Evil_Laugh.au"
    when 9 : return "sounds/cat_1.au"
    when 10 : return "sounds/whoopee.au"
    when 11 : return "sounds/giggle.au"
    when 12 : return "sounds/puke.au"
    when 13 : return "sounds/yell.au"
    when 14 : return "sounds/siren_1.au"
    when 15 : return "sounds/bart_laugh.au"
    when 16 : return "sounds/Evil_Laugh.au"
    when 17 : return "sounds/cat_1.au"
    when 18 : return "sounds/whoopee.au"
    when 19 : return "sounds/giggle.au"
    when 20 : return "sounds/puke.au"
    when 21 : return "sounds/yell.au"
    when 22 : return "sounds/siren_1.au"
    when 23 : return "sounds/bart_laugh.au"
    when 24 : return "sounds/Evil_Laugh.au"
    when 25 : return "sounds/cat_1.au"
    when 26 : return "sounds/whoopee.au"
    when 27 : return "sounds/giggle.au"
    when 28 : return "sounds/puke.au"
    when 29 : return "sounds/yell.au"
    when 30 : return "sounds/siren_1.au"
    when 31 : return 'sounds/cat_1.au'
    end
  end
end
