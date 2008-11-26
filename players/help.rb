module Help

  def mouse_entered(e)
    style.text_color = "#1a1"
    #update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
    #update_now
  end
  
  def mouse_clicked(e)
    @clicked = false if @clicked.nil?
    screen = scene.find("help_screen")
    if @clicked == false
      screen.style.width = "200"
      screen.style.height = "200"
      screen.text = "Your objective is to prevent the creep from traveling from the top left of the screen to the bottom right.  You must build towers by clicking on them in the build panel and placing them on the screen.  You may not block the creep. Good luck."
      #screen.update
      @clicked = true
    else
      screen.style.width = "0"
      screen.style.height = "0"
      #screen.update
      @clicked = false
    end
  end
  
end