module Restart
  def mouse_entered(e)
    style.text_color = "#1a1"
   # update
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
   # update
  end
  
  def mouse_clicked(e)
    screen = scene.find("menu_screen")
    screen.style.width = "0"
    screen.style.height = "0"
    #screen.update
    help_screen = scene.find("help_screen")
    help_screen.style.width = '0'
    help_screen.style.height = '0'
    #help_screen.update
    frame = scene.find("space_frame")
    frame.new_game
    label = scene.find("game_over_message")
    label.style.width = '0'
    label.style.height = '0'
  #  label.update
    container = scene.find("next_creep_display")
    container.style.background_image = "images/creep/creep1.png"
   # container.update
    win_screen = scene.find("win_screen")
    win_screen.style.width = '0'
    win_screen.style.height = '0'
   # win_screen.update
  end
end