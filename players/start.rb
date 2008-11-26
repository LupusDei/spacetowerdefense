module Start
  
  def mouse_entered(e)
    style.text_color = "#1a1"
    #update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
    #update_now
  end
  
  def mouse_clicked(e)
    scene.find("space_frame").start
  end
end