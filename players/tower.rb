module Tower
  LEFT_CLICK = 1
  attr_accessor :tower_reference
  
  def mouse_clicked(e)
    if e.button == LEFT_CLICK
      frame = scene.find("space_frame")
      frame.select_new_tower(self)
    end
  end

end
