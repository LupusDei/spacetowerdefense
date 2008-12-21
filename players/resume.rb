module Resume
  def mouse_entered(e)
    style.text_color = "#1a1"
    #update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
   # update_now
  end
  
  def mouse_clicked(e)
    screen = scene.find("menu_screen")
    screen.style.width = "0"
    screen.style.height = "0"
    #screen.update
    help_screen = scene.find("help_screen")
    help_screen.style.width = '0'
    help_screen.style.height = '0'
  #  help_screen.update
    about_screen = scene.find("about_screen")
    about_screen.style.width = '0'
    about_screen.style.height = '0'
   # about_screen.update
    frame = scene.find("space_frame")
    frame.space.pause = false if frame.space != nil
    label = scene.find("game_over_message")
    label.style.width = '0'
    label.style.height = '0'
   # label.update
  end
end