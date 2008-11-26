class Lives
  
  attr_accessor :lives
  
  def initialize(lives)
    @lives = lives
  end
  
  def lost_life
    @lives -= 1
  end
  
  def lives_left?
    @lives > 0
  end
end