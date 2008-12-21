
class Block
  SIZE=40
  attr_accessor  :top_left, :top_right, :bottom_left, :bottom_right
  def initialize(x,y)
    @top_left = x,y
    @bottom_right = (x + SIZE) , (y + SIZE)
    @bottom_left = x, (y + SIZE)
    @top_right = (x + SIZE), y
    @top_connection = false
    @bottom_connection = false
    @right_connection = false
    @left_connection = false
  end
  
  def top
    x,y = @top_left
    y
  end
  def bottom
    x,y = @bottom_left
    y
  end
  def right
    x,y = @top_right
    x
  end
  def left
    x,y = @top_left
    x
  end
  
  def combine_right(block)
    self.top_right = block.top_right
    self.bottom_right = block.bottom_right
    return self
  end
  
  def combine_left(block)
    self.top_left = block.top_left
    self.bottom_left = block.bottom_left
    return self
  end
  
  def combine_top(block)
    self.top_left = block.top_left
    self.top_right = block.top_right
    return self
  end
  
  def combine_bottom(block)
    self.bottom_right = block.bottom_right
    self.bottom_left = block.bottom_left
    return self
  end

  def neighbor?(block)
    adjacent_above_or_below = (block.top <= bottom and block.bottom >= top)
    adjacent_left_or_right = (block.right >= left and block.left <= right)
    adjacent_above_or_below and adjacent_left_or_right
  end   

  def connect_to(block)
    connect_to_top if block.connected_to_top?
    block.connect_to_top if connected_to_top?
    connect_to_bottom if block.connected_to_bottom?
    block.connect_to_bottom if connected_to_bottom?
    connect_to_right if block.connected_to_right?
    block.connect_to_right if connected_to_right?
    connect_to_left if block.connected_to_left?
    block.connect_to_left if connected_to_left?
  end
  
  def disconnect
    @top_connection = false
    @bottom_connection = false
    @right_connection = false
    @left_connection = false
  end
  
  def connect_to_top
    @top_connection = true
  end
  
  def disconnect_from_top
    @top_connection = false
  end
  
  def connected_to_top?
    @top_connection
  end
  
  def connect_to_bottom
    @bottom_connection = true
  end
  
  def disconnect_from_bottom
    @bottom_connection = false
  end
  
  def connected_to_bottom?
    @bottom_connection
  end
  
  def connect_to_right
    @right_connection = true
  end
  
  def disconnect_from_right
    @right_connection = false
  end
  
  def connected_to_right?
    @right_connection
  end
  
  def connect_to_left
    @left_connection = true
  end
  
  def disconnect_from_left
    @left_connection = false
  end
  
  def connected_to_left?
    @left_connection
  end
  
end