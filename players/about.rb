module About

  def mouse_entered(e)
    style.text_color = "#1a1"
   # update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
   # update_now
  end
  
  def mouse_clicked(e)
    @clicked = false if @clicked.nil?
    screen = scene.find("about_screen")
    if @clicked == false
      screen.style.width = "200"
      screen.style.height = "200"
      screen.text = "This Game was created by Justin Martin, June-July 2008, for 8th-Light and Micah Martin. It was created using the UI framework of Limelight, which was created by Micah Martin."
     # screen.update
      @clicked = true
    else
      screen.style.width = "0"
      screen.style.height = "0"
    #  screen.update
      @clicked = false
    end
  end
  
end