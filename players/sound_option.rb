module SoundOption
  def mouse_entered(e)
    style.text_color = "#1a1"
    #update_now
  end
  
  def mouse_exited(e)
    style.text_color = "#1f1"
    #update_now
  end
  
  def mouse_clicked(e)
    frame = scene.find("space_frame")
    if self.text == "Sound: On"
      self.text = "Sound: Off"
      frame.sound_option = false
    else
      self.text = "Sound: On"
      frame.sound_option = true
    end
    #self.update
  end
end