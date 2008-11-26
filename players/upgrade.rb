module Upgrade
  
  def mouse_entered(e)
    style.text_color = "#1a1"
    #update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
  #  update_now
  end
  
  def mouse_clicked(e)
    frame = scene.find("space_frame")
    frame.upgrade
  end
end