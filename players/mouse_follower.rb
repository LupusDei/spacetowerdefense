module MouseFollower
  
  def mouse_clicked(e)
    space_frame = scene.find("space_frame")
    space_frame.mouse_clicked(e) if not space_frame.nil?
  end
end