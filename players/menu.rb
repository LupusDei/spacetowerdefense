module Menu
  def mouse_entered(e)
    style.text_color = "#1a1"
    #update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
    #update_now
  end
  
  def mouse_clicked(e)
    screen = scene.find("menu_screen")
    screen.style.transparency = "70"
    screen.style.width = "200"
    screen.style.height = "400"
    #screen.style.x = "300"
    #screen.style.y = "300"
    #screen.update_now
    frame = scene.find("space_frame")
    frame.space.pause = true if frame.space != nil
  end
end