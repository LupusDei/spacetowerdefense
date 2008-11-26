module Cancel
  def mouse_entered(e)
    style.text_color = "#1a1"
   # update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
    #update_now
  end
  
  def mouse_clicked(e)
    screen = scene.find("quit_screen")
    screen.style.width = "0"
    screen.style.height = "0"
    #screen.update_now
    screen = scene.find("menu_screen")
    screen.style.width = "200"
    screen.style.height = "400"
    #screen.update_now
  end
end