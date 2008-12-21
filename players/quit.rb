module Quit
  def mouse_entered(e)
    style.text_color = "#1a1"
    #update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
    #update_now
  end
  
  def mouse_clicked(e)
    screen = scene.find("quit_screen")
    screen.style.width = "200"
    screen.style.height = "60"
    #screen.update
    screen = scene.find("menu_screen")
    screen.style.width = "0"
    screen.style.height = "0"
    #screen.update
    help_screen = scene.find("help_screen")
    help_screen.style.width = '0'
    help_screen.style.height = '0'
    #help_screen.update
    about_screen = scene.find("about_screen")
    about_screen.style.width = '0'
    about_screen.style.height = '0'
    #about_screen.update
  end
end